trigger CT_PrjctReachCalForMediaCampaign on Interview_Pitches__c (after delete, after insert, after undelete, after update) {
	List<Interview_Pitches__c> IPList = new List<Interview_Pitches__c>();
	Set<ID> mcIdSet = new Set<ID>();		
	if(trigger.isDelete){
		IPList = trigger.old;
	} else {	
		if(trigger.new != null && trigger.new.size() > 0){
			IPList = trigger.new;
		}
	 }
	for(Interview_Pitches__c ipObj : IPList){
		mcIdSet.add(ipObj.Media_Campaign__c);
	}
	if(mcIdSet.size() > 0){
		List<Interview_Pitches__c> ipTotalList = new List<Interview_Pitches__c>([Select i.SystemModstamp, i.Status__c, i.Name, i.Media_Campaign__c, i.LastModifiedDate, i.LastModifiedById, i.LastActivityDate, i.IsDeleted, i.Id, i.CreatedDate, i.CreatedById, i.ConnectionSentId, i.ConnectionReceivedId From Interview_Pitches__c i where Media_Campaign__c IN: mcIdSet]);
		List<Interview_Pitches__c> ipPublishedList = new List<Interview_Pitches__c>([Select i.SystemModstamp, i.Status__c, i.Name, i.Media_Campaign__c, i.LastModifiedDate, i.LastModifiedById, i.LastActivityDate, i.IsDeleted, i.Id, i.CreatedDate, i.CreatedById, i.ConnectionSentId, i.ConnectionReceivedId From Interview_Pitches__c i where Media_Campaign__c IN: mcIdSet and Status__c = 'Interview Published']);
		
		Map<String, Integer> mapMcIp = new Map<String, Integer>();
		Integer ipTotal = 0;
		for(Interview_Pitches__c ipObj : ipTotalList){
			if(mapMcIp.containskey(ipObj.Media_Campaign__c)){
				ipTotal++;
				system.debug('===========ipTotal=========='+ipTotal);
				mapMcIp.put(ipObj.Media_Campaign__c, ipTotal);
				system.debug('==============mapMcIp=========' +mapMcIp);
			}else {
				ipTotal = 1;
				mapMcIp.put(ipObj.Media_Campaign__c, ipTotal);
			}
		}
		
		Map<String, Integer> mapMcIpWithIntrvwPub = new Map<String, Integer>();
		Integer ipPublishedTotal = 0;
		for(Interview_Pitches__c ipObj : ipPublishedList){
			if(mapMcIpWithIntrvwPub.containskey(ipObj.Media_Campaign__c)){
				ipPublishedTotal++;
				mapMcIpWithIntrvwPub.put(ipObj.Media_Campaign__c, ipPublishedTotal);
			}else {
				ipPublishedTotal = 1;
				mapMcIpWithIntrvwPub.put(ipObj.Media_Campaign__c, ipPublishedTotal);
			}
		}
		
		List<Media_Campaign__c> mcList = new List<Media_Campaign__c>([select Name, Projected_Reach__c from Media_Campaign__c Where Id in : mcIdSet]);
		
		for(Media_Campaign__c mc : mcList ){			
			Integer totalCount = mapMcIp.get(mc.Id);
			system.debug('=============totalCount========='+ totalCount);
			Integer intpubCount = mapMcIpWithIntrvwPub.get(mc.Id);
			system.debug('=============intpubCount========='+ intpubCount);
			Decimal value = 0.0;
			if(intpubCount!=null && intpubCount!=0 && totalCount!=null && totalCount!=0)
				value =   (decimal.valueOf(intpubCount) / decimal.valueOf(totalCount)) * 0.5 ;
				system.debug('=============Value========='+ value);
			mc.Projected_Reach__c = value ;
		}
		
		if(mcList.size()>0)
			update mcList;
		
	}	
}