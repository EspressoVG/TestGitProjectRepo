public with sharing class AdvVFWebinarViewStateExtension {



    /* instance variables */
    public  Account                      acc             { get; set; }
    public  Contact                      primaryContact  { get; set; }
    public  Opportunity                  opp             { get; set; }
    private List<Contact>                allContacts     { get; set; }
    private List<OpportunityContactRole> oppRoles        { get; set; }
    public  Boolean                      isDecisionMaker { get; set; }
    public  String                       moreNames       { get; set; }



    /* constructor */
    public AdvVFWebinarViewStateExtension(ApexPages.StandardController sc) {
        this.acc            = (Account)sc.getRecord();
        this.primaryContact = new Contact();
        this.opp            = new Opportunity(StageName = 'Prospecting');
        this.allContacts    = new List<Contact>();
        this.oppRoles       = new List<OpportunityContactRole>();
    }



    /* page actions */
    public PageReference save() {
        PageReference currPage = ApexPages.currentPage().setRedirect(false);
        try {
            upsertAccount();
            upsertOpportunity();
            upsertContacts();
            upsertOpportunityContactRoles();
        } catch (DmlException x) {
            this.allContacts.clear();
            this.oppRoles.clear();
            return currPage;
        }
        return new PageReference('/' + this.acc.Id);
    }



    /* private methods */
    private void upsertAccount() {
        upsert this.acc;
    }


    private void upsertOpportunity() {
        this.opp.AccountId = this.acc.Id;
        upsert this.opp;
    }


    private void upsertContacts() {

        // deal with the primary contact first
        this.primaryContact.AccountId = this.acc.Id;
        this.allContacts.add(this.primaryContact);

        // now let's deal with the additional contact names that were supplied.
        // let's break apart the comma-separated list of names first, then separate
        // each of _those_ items into first name and last name
        List<String> moreNamesList = (moreNames != null && moreNames != '') ? moreNames.split(',') : new List<String>();
        List<String> firstLast;
        String lName;
        if (moreNamesList.size() > 0) {
            for (String s : moreNamesList) {
                s = s.trim();
                firstLast = s.split(' ');
                lName = firstLast.size() > 1 ? firstLast[1] : 'UNKNOWN';
                this.allContacts.add(new Contact(FirstName = firstLast[0], LastName = lName, AccountId = this.acc.Id));
            }
        }

        upsert this.allContacts;
    }


    private void upsertOpportunityContactRoles() {

        Boolean primary;
        String oppRole;
        for (Contact c : this.allContacts) {
            if (c.Id == this.primaryContact.Id) {
                primary = true;
                oppRole = isDecisionMaker ? 'Decision Maker' : 'Influencer';
            } else {
                primary = false;
                oppRole = 'Influencer';
            }
            this.oppRoles.add(new OpportunityContactRole(ContactId = c.Id, isPrimary = primary, OpportunityId = this.opp.Id, Role = oppRole));
        }

        upsert this.oppRoles;
    }


    @isTest
    private static void testSaveSuccessful() {
        AdvVFWebinarViewStateExtension vse = getInstance();
        // valid close date (must be greater or equal to today)
        vse.opp.CloseDate = Date.today() + 30;
        PageReference pr = vse.save();
        System.assert(vse.acc.Id != null, 'Account insertion not successful.');
        System.assert(vse.primaryContact.Id != null, 'Contact insertion not successful.');
        System.assert(vse.opp.Id != null, 'Opportunity insertion not successful.');
        List<OpportunityContactRole> ocr = [SELECT Id FROM OpportunityContactRole WHERE OpportunityId = :vse.opp.Id];
        System.assert(ocr != null && ocr.size() == 3, 'Opportunity-Contact Role insertion not successful.');
        System.assert(pr.getUrl().indexOf(vse.acc.Id) != -1, 'Should have been redirected to account detail page.');
    }


    @isTest
    private static void testSaveFailedBecauseOfOpportunityValidationRule() {
        AdvVFWebinarViewStateExtension vse = getInstance();
        // invalid close date (must be greater or equal to today)
        vse.opp.CloseDate = Date.today() - 30;
        PageReference pr1 = Page.AdvVFWebinarViewState;
        PageReference pr2 = vse.save();
        System.assert(pr1.getUrl() == pr2.getUrl(), 'Should not have been redirected.');
    }


    private static AdvVFWebinarViewStateExtension getInstance() {
        PageReference pageToTest = Page.AdvVFWebinarViewState;
        Test.setCurrentPageReference(pageToTest);
        AdvVFWebinarViewStateExtension vse = new AdvVFWebinarViewStateExtension(new ApexPages.StandardController(new Account()));
        vse.acc.Name = 'New Account';
        vse.primaryContact.FirstName = 'First';
        vse.primaryContact.LastName = 'Last';
        vse.opp.Name = 'New Opp';
        vse.isDecisionMaker = false;
        vse.moreNames = 'Bah Bah, Dah Dah';
        return vse;
    }



}