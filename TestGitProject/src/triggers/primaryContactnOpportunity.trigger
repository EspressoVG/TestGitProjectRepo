trigger primaryContactnOpportunity on Opportunity (Before insert, Before update, After insert) {
    //Set for AccountIds to query contacts accounts wise.    
    Set<Id> accountIds = new Set<ID>();
    //Map for account-contacts  :  key -accountId &&  value - Map of all child contacts.
    Map<id, Map<id, Contact>> contactsonAccountMap = new Map<id, Map<id, Contact>>();
    //Map for OpportunityId - OpportunityContactRoles   : key - opportunityID && value : List of OpportunityContactRole where Opportunity is key opportunityId
    Map<Id, List<OpportunityContactRole>> pContactMap = new Map<Id, List<OpportunityContactRole>>();
    //Set for all Opportunity Ids in case of after insert and before update;
    Set<Id> oppIds = new Set<Id>();
    
    
    for(Opportunity opp : Trigger.new){
        if(opp.AccountID != null){
            accountIds.add(opp.AccountId);
            if((trigger.isAfter && trigger.isInsert)||trigger.isUpdate)
                oppIds.add(opp.Id);
        }
    }
    
    system.debug('accountIds===='+accountIds);
    
    if(accountIds.size() > 0){
        for(Account acc : [SELECT id, Name, (Select id, firstName, LastName from Contacts) 
                             FROM Account
                            WHERE id in : accountIds]){
            if(acc.Contacts != null && acc.Contacts.size() > 0){
                contactsonAccountMap.put(acc.id, new Map<id, Contact>()); 
                for(Contact con : acc.Contacts){
                    contactsonAccountMap.get(acc.id).put(con.id, con);
                }
            }
        }
    }
    
   system.debug('contactsonAccountMap===='+ contactsonAccountMap);
   
   //Show error Messege if selected Account does not contains any child contact.
    
   if(trigger.isInsert && trigger.isBefore){
        system.debug('in insert ====');
       
        for(Opportunity opp : trigger.New){
            system.debug('AccountId ===='+ opp.AccountId );
            if(opp.AccountId != null && !contactsonAccountMap.containsKey(opp.AccountId)){
                system.debug('Error====');
                String Msg  = '<a href="/'+opp.AccountId +'"' + ' Target= "_blank" >Account</a>';
               opp.addError('Please add at least one contact on '+ Msg +'. Primary Contact is mandatory.');
            }
                
        }
    }
    
    //show error messege if opportunity stage is changing and there is no PrimaryContact on the opportunity.
    
    if(trigger.isUpdate && trigger.isBefore){
        for(OpportunityContactRole ocr : [SELECT Role, OpportunityId, IsPrimary, Id, ContactId 
                                            FROM OpportunityContactRole 
                                           WHERE isPrimary = true and OpportunityId in : oppIds]){
            if(pContactMap.containsKey(ocr.OpportunityId ))
                pContactMap.get(ocr.OpportunityId).add(ocr);  
            else{
                pContactMap.put(ocr.OpportunityId, new List<OpportunityContactRole>());
                pContactMap.get(ocr.OpportunityId).add(ocr);
            }  
        } 
        
        for(Opportunity opp : trigger.new){
            Opportunity oldOpp = Trigger.oldMap.get(opp.id);
            if(opp.StageName != null && opp.StageName != oldOpp.StageName ){
                if(!pContactMap.containskey(opp.id)){
                    opp.addError('The stage can not be change without having primary Contact.');
                }
           }    
        }
    }
    
    
    
    // Select one contact from Account which is using as primary contact on many Opportunities more than  contacts.
    // in case of tie select first.
    //after selecting contact insert one record of OpportunityContactRole
    if(trigger.isAfter){
        Set<Id> allContactIdSet = new Set<Id>();
        if(contactsonAccountMap.size() > 0){
            for(id accId : contactsonAccountMap.keySet()){
                allContactIdSet.addAll(contactsonAccountMap.get(accId).KeySet());    
            }  
        }
        Map<id, List<OpportunityContactRole>> contactbyOCRoleMap = new Map<id, List<OpportunityContactRole >>();
        if(allContactIdSet.size() > 0){
            for(OpportunityContactRole ocRole :[SELECT Role, OpportunityId, IsPrimary, Id, ContactId 
                                                  FROM OpportunityContactRole 
                                                 WHERE ContactId in : allContactIdSet and isPrimary = true]){
                 
                 if(contactbyOCRoleMap.containsKey(ocRole.ContactId))
                     contactbyOCRoleMap.get(ocRole.ContactId).add(ocRole);
                     
                 else{
                     contactbyOCRoleMap.put(ocRole.ContactId , new List<OpportunityContactRole>());
                     contactbyOCRoleMap.get(ocRole.ContactId).add(ocRole);
                 }
             }      
        }
        List<OpportunityContactRole> ocrObjList = new List<OpportunityContactRole>();
        for(Opportunity o : trigger.new){
            
            if(o.AccountId != null){
                String conId = '';
                if(contactsonAccountMap.containsKey(o.AccountID)){
                    Integer mapSize = 0;
                    for(Id cId : contactsonAccountMap.get(o.AccountID).keySet()){
                        if(contactbyOCRoleMap.containsKey(cId) && contactbyOCRoleMap.get(cId).size() > mapSize){
                            conId = cId ;
                            mapSize = contactbyOCRoleMap.get(cId).size();
                        }
                            
                    }
                    if(conId  == ''){
                        for (Id cId :  contactsonAccountMap.get(o.AccountID).keySet()){
                            conId = cId;
                            break;
                        }
                    }
                }  
                if(conId != ''){
                    OpportunityContactRole  ocrObj = new OpportunityContactRole(
                                                         opportunityId = o.id,
                                                         ContactId = conId ,
                                                         isPrimary = true  
                                                         );
                    ocrObjList.add(ocrObj);
                }  
            }    
        }
        if(ocrObjList.size() > 0){
            insert ocrObjList ;
        }
    }
}