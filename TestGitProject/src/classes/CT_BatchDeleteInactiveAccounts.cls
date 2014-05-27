global class CT_BatchDeleteInactiveAccounts implements Database.Batchable<sObject> {
	global String Query;
	
	global CT_BatchDeleteInactiveAccounts() 
	{
		Query = 'Select a.Website, a.UpsellOpportunity__c, a.Type, a.TickerSymbol, a.Target_Date__c, a.SystemModstamp, a.Site, a.Sic, a.ShippingStreet, a.ShippingState, a.ShippingPostalCode, a.ShippingCountry, a.ShippingCity, a.SLA__c, a.SLASerialNumber__c, a.SLAExpirationDate__c, a.Rating, a.Phone, a.ParentId, a.Ownership, a.OwnerId, a.NumberofLocations__c, a.NumberOfEmployees, a.Name, a.MasterRecordId, a.LastModifiedDate, a.LastModifiedById, a.LastActivityDate, a.JigsawCompanyId, a.Jigsaw, a.Is_Active__c, a.IsDeleted, a.Industry, a.Id, a.Fax, a.Description, a.CustomerPriority__c, a.CreatedDate, a.CreatedById, a.BillingStreet, a.BillingState, a.BillingPostalCode, a.BillingCountry, a.BillingCity, a.AnnualRevenue, a.Active__c, a.AccountNumber From Account a where a.Is_Active__c  = true ';
	}
	
	global Database.Querylocator  start(Database.BatchableContext BC)
	{
		return Database.getQuerylocator(Query);
	}
	
	
	global void execute(Database.BatchableContext BC, List<sObject> accList) 
	{
		System.debug('-=======accList=========' + accList);
		delete accList;
	}

	global void finish(Database.BatchableContext BC)
	{
	/*	CT_ScheduleBatchAccount m = new CT_ScheduleBatchAccount();
		String sch = '0 25 14 27 2 2012';
		system.schedule('Batch Job', sch, m);
	 */
	} 
}