trigger CT_OliListAddOnOppInsert on Opportunity (after insert) {
	List<Opportunity> oppList = new List<Opportunity>();
	List< OpportunityLineItem> oliList = new List<OpportunityLineItem>();
	List<PricebookEntry> productList = new List<PricebookEntry>();
	Set<String> setOppID = new set<String>();
	
	if(Trigger.new !=null && Trigger.new.size()>0){
		for(Opportunity oppObj : trigger.new){
			setOppId.add(oppObj.Id);
			oppList.add(oppObj);
		}
		
		Pricebook2 priceBookObj = new Pricebook2();
		priceBookObj = [Select p.SystemModstamp, p.Name, p.LastModifiedDate, p.LastModifiedById, p.IsStandard, p.IsDeleted, p.IsActive, p.Id, p.Description, p.CreatedDate, p.CreatedById From Pricebook2 p where Name = 'SampleBookForTrigger'  limit 1];
		
		productList = [Select p.Pricebook2Id, p.Name, p.UnitPrice From PricebookEntry p where PricebookEntry.Pricebook2Id =: priceBookObj.Id];
		
		for(Opportunity oppObj : OppList){
			for(PricebookEntry pbookEntryObj : productList){
				OpportunityLineItem oliObj = new OpportunityLineItem();
				oliObj.PricebookEntryId = pbookEntryObj.Id;
				oliObj.OpportunityId = oppObj.Id;
				oliObj.Quantity = 5;
				oliObj.UnitPrice = pbookEntryObj.UnitPrice;
				oliList.add(oliObj);
			}
		}
			If(oliList !=null && oliList.size()>0)
				insert oliList;
		}
}