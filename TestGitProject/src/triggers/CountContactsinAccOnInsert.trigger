trigger CountContactsinAccOnInsert on Contact (after insert) {
    Contact c = new Contact();
    Integer cCount;
    String accId;
    
    if(trigger.new[0] != null){
        String currentURL = URL.getCurrentRequestUrl().toExternalForm();
        String comparisonURL = URL.getSalesforceBaseUrl().toExternalForm() ;
        system.debug('currentURL:::'+ currentURL);
        system.debug('comparisonURL:::'+ comparisonURL);
        c = trigger.new[0];
        accId = c.AccountId;
    }
    if(accId != null && accId != ''){
        List<Contact> lstCon = [Select c.Name, c.Id, c.AccountId From Contact c where c.AccountId =: accId];
        cCount = lstCon.size();
        Account[] acc = [Select a.CountOfContacts__c, a.Id From Account a where a.Id =: accId];
        acc[0].CountOfContacts__c = cCount;
        update acc;
    }
}