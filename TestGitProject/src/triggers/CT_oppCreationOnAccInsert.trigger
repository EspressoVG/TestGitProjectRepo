trigger CT_oppCreationOnAccInsert on Account (after insert, after update) {
    list<Opportunity> oppList = new List<Opportunity>();
    if(Trigger.new !=null && Trigger.new.size()>0)
    {
        if(Trigger.isInsert){
            for(Account a : trigger.new){
                Opportunity oppObj = new Opportunity();
                oppObj.AccountId = a.Id;
                oppObj.CloseDate = a.Target_Date__c;
                oppObj.Name = a.Name;
                oppObj.StageName  = 'Prospecting';
                oppList.add(oppObj);
            }
                if(oppList.size()>0 && oppList !=null)
                    insert oppList;
        }
        if(Trigger.isUpdate){
            List<Opportunity> allOppList = new List<Opportunity>();
            Set<String> setAccId = new Set<String>();
            for(Account a :trigger.new){
                setAccId.add(a.Id);
            }
            allOppList = [Select o.StageName, o.Name, o.Id, o.AccountId, Account.Target_Date__c From Opportunity o where AccountId in: setAccId];
            for(Opportunity oppObj : allOppList){
                oppObj.Closedate = oppObj.Account.Target_Date__c;
            }
            if(allOppList!=null && allOppList.size()>0)
                update allOppList;
        }
    }
}