trigger TestAfterUpdateAccount on Account (after update) {
    for(Account acc : trigger.new){
        if(acc != trigger.oldMap.get(acc.Id)){
                system.debug('----Into if---');
                
                acc.SLASerialNumber__c += acc.SLASerialNumber__c;
        }
        system.debug('----Into Skipped---');
    }
}