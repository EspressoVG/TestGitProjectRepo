trigger mp_OppProductToAssetMapping on Opportunity (after update) {
	List<Opportunity> oppList = trigger.new;
	List<Asset> assetList = new List<Asset>();
	
	if(oppList != null && oppList.size()> 0 ){
		for(Opportunity opp : oppList){
			if(opp.StageName == 'Closed Won' && opp.AccountId != null){
				for(OpportunityLineItem oli : [Select o.UnitPrice, o.TotalPrice, o.SystemModstamp, o.SortOrder, o.ServiceDate, o.Quantity, o.Product_Code__c, o.PricebookEntryId, o.OpportunityId, o.ListPrice, o.LastModifiedDate, o.LastModifiedById, o.IsDeleted, o.Id, o.Description, o.CreatedDate, o.CreatedById, o.ConnectionSentId, o.ConnectionReceivedId From OpportunityLineItem o WHERE o.OpportunityId =: opp.Id]){
					Asset ast = new Asset();
					ast.AccountId = opp.AccountId;
			        ast.Quantity = oli.Quantity;
			        ast.Price =  oli.UnitPrice;
			        ast.Name = 'test asset';
			        assetList.add(ast);	
				}
			}
		}
		if(assetList != null && assetList.size()> 0){
			insert assetList;
		}
		
	}
}