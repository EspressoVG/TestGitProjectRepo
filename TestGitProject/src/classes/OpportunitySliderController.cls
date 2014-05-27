global with sharing class OpportunitySliderController {

	public List<Opportunity> opportunities {get; set;}
	public List<Account> accounts {get; set;}
	public Id accountId {get; set;}
	
	public OpportunitySliderController() {
		accounts = [SELECT Id, Name from Account];
	}
	
	public PageReference selectAccount() {
		opportunities = [SELECT Id, Name, Amount from Opportunity WHERE AccountId =: accountId];
		return null;
	}
	
	public PageReference updateOpportunities() {
		update opportunities;
		
		return null;
	}
	
	//REMOTE Functions
	@RemoteAction
    global static List<Opportunity> selectAccountRemote(string accountIdRemote) {
    	List<Opportunity> opportunities = [SELECT Id, Name, Amount from Opportunity WHERE AccountId =: accountIdRemote];
		return opportunities;	
    }
    
    @RemoteAction
    global static Boolean updateOpportunity(string oppId, integer amount) {
    	Opportunity o = [SELECT Id, Amount from Opportunity WHERE Id =: oppId];
    	o.Amount = amount;
    	update o;
    	
    	return true;
    }


	@isTest
	global static void testEverything() {
		Account a = new Account(Name='TestCo');
		insert a;
		Opportunity o = new Opportunity(Name='TestOpp',AccountId=a.Id,StageName='Closed',CloseDate=date.parse('12/27/2009'));
		insert o;
		OpportunitySliderController controller = new OpportunitySliderController();
		System.assertNotEquals(controller.accounts.size(),0);
		controller.accountId = a.Id;
		controller.selectAccount();
		System.assertNotEquals(controller.opportunities.size(),0);	
		controller.opportunities = OpportunitySliderController.selectAccountRemote(a.Id);
		System.assertNotEquals(controller.opportunities.size(),0);	
		Boolean result = OpportunitySliderController.updateOpportunity(o.Id,5000);
		System.assertEquals(true,result);
		controller.updateOpportunities();
		
	}

}