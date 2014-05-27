trigger setPriaryContactOnOpportunity on Opportunity (after insert, before update) {
    Map<Id, Integer> oppConMap = new Map<Id, Integer>(); // map of Contacts in OpportunityContactRole and their number of how many times they have been Primary Contact
    Map<Id, OpportunityContactRole> oCRMap = new Map<Id, OpportunityContactRole>(); // Map of OCR id and OCR Object
    Map<Id, OpportunityContactRole> oppIdOcrObjMap = new Map<Id, OpportunityContactRole>();
    List<OpportunityContactRole> oCRList = [Select o.SystemModstamp, o.Role, o.OpportunityId, o.LastModifiedDate, 
                                            o.LastModifiedById, o.IsPrimary, o.IsDeleted, o.Id, o.CreatedDate, 
                                            o.CreatedById, o.ContactId From OpportunityContactRole o WHERE Isprimary = TRUE]; // getting all OCR where prmianry contact is there.
    system.debug('------oCRList-------' + oCRList);
    for(OpportunityContactRole oCR : oCRList){
        if(oppConMap.containsKey(oCR.Id)){
            oppConMap.put(oCR.ContactId, oppConMap.get(oCR.ContactId) + 1);
            system.debug('------oppConMap-------' + oppConMap);
        }else{
            oCRMap.put(oCR.Id, oCR);
            system.debug('------oCRMap-------' + oCRMap);
            
            oPPConMap.put(oCR.ContactId, 1);
            system.debug('------oppConMap-------' + oppConMap);
            
            oppIdOcrObjMap.put(oCR.OpportunityID , oCR);
            system.debug('------oppIdOcrObjMap-------' + oppIdOcrObjMap);
        }                                   
    }
    List<Contact> conList = [Select Id FROM Contact WHERE Id IN : oppConMap.keySet()];
    system.debug('------conList-------' + conList);
    Id maxCon = conList[0].Id; 
    for(Contact c : conList){
        if(oppConMap.get(c.Id) > oppConMap.get(maxCon)){
            maxCon = c.Id;
        }           
    }
    List<OpportunityContactRole> oCRListToInsert = new List<OpportunityContactRole>();
        
    if(trigger.isBefore){
        if(trigger.isUpdate){
            for(Opportunity oppObj : trigger.new){
                if(!oppIdOcrObjMap.containsKey(oppObj.Id)){
                    OpportunityContactRole oCRObj = new OpportunityContactRole();
                    oCRObj.ContactId = maxCon;
                    oCRObj.OpportunityId = oppObj.Id;
                    oCRObj.IsPrimary = TRUE;
                    oCRListToInsert.add(oCRObj);
                }
            }
            insert oCRListToInsert;
        }
    }
    if(trigger.isAfter){
        if(trigger.isInsert){
            for(Opportunity oppObj : trigger.new){
                if(!oppIdOcrObjMap.containsKey(oppObj.Id)){
                    OpportunityContactRole oCRObj = new OpportunityContactRole();
                    oCRObj.ContactId = maxCon;
                    oCRObj.OpportunityId = oppObj.Id;
                    oCRObj.IsPrimary = TRUE;
                    oCRListToInsert.add(oCRObj);
                }
            }
            insert oCRListToInsert;
        }
    }
}