@isTest (seeallData = true)
private class CT_OppSearchButtonTest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        //edit 5
        Test.startTest();
        Account acc = new Account();
        List<Opportunity> oppList = new List<Opportunity>();
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
        
        acc.Name = 'test1';
        acc.Target_Date__c = Date.Today();
        insert acc;
        
        oppList = [Select o.StageName, o.CloseDate, o.Name, o.Id, o.AccountId, Account.Target_Date__c From Opportunity o where AccountId =: acc.Id limit 1];
        for(Opportunity opp : oppList){
            System.assertEquals(acc.Target_Date__c, opp.CloseDate);
        }
        
        acc.Name = 'test1Update';
        acc.Target_Date__c = Date.Today()+ 2;
        update acc;
        
        List<Opportunity> oppList1 = new List<Opportunity>([Select o.StageName, o.CloseDate, o.Name, o.Id, o.AccountId, Account.Target_Date__c From Opportunity o where AccountId =: acc.Id limit 1]);
        for(Opportunity opp1 : oppList1){
            System.assertEquals(acc.Target_Date__c, opp1.CloseDate);
        }
        
        
        
      /*  Account acc1 = [Select a.Name, a.Target_Date__c from Account a where Name = 'test1'];
        acc1.Name = 'test1Upadate';
        acc1.Target_date__c = Date.Today() + 2 ; */
        
     // ApexPages.currentPage().getParameters().put('Id', acc.Id); 
        ApexPages.currentPage().getParameters().put('accountId', acc.Id);
        CT_SearchOpportunityButtonController con = new CT_SearchOpportunityButtonController();
        delete oppList1;
        con.SearchMe();
        con.BackButton();
        Test.stopTest();
    }
}