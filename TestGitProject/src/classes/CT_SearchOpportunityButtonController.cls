/*
* @author : CloudTrigger LLC
* @descrption : This class will search the Opportunities related to the selected Account from the Standard object "Opportunity" based upon the
                ID of that current Account Record in the URL.
* @date : 03/22/2012
*/
public  class CT_SearchOpportunityButtonController {
	public String accId;
	public List<Opportunity> oppList{get;set;}

	
	public CT_SearchOpportunityButtonController(){
		if(System.currentPageReference() != null &&
				System.currentPageReference().getParameters() != null &&
				System.currentPageReference().getParameters().get('accountId') != null) {
					
				accId = (String) System.currentPageReference().getParameters().get('accountId');
		}
		oppList = new List<Opportunity>();
		SearchMe();
	}
/*
* @author : CloudTrigger
* @date : 03/22/2012
* @description : Apex method for producing  list of Opprotunities based ID of Current Account in the URL.
* @parameters : Nothing 
* @returns : null
*/		
		
		public pageReference SearchMe(){
			try{
				String qry;
				if(accId != null)
				qry = 'Select o.Id, o.Name, o.StageName, o.CloseDate, o.Amount from Opportunity o Where AccountId =: accId  Order By o.Name';
				system.debug('========Query String=======' + qry);
				oppList = Database.query(qry);
				if(oppList != null && oppList.size()> 0){
					Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.Confirm,'Below are your Opportunities'));
				}else{
					Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.Error,'Sorry! No Opportunities are for this Account'));
				}
			}catch(Exception e){
				system.debug('===================Exception=======' +e);
				}
			return null;
		}
/*
* @author : CloudTrigger
* @date : 03/22/2012
* @description : Apex method for redirecting user back to the previous Account user has viewed.
* @parameters : Nothing 
* @returns : null
*/		
		public pageReference BackButton(){
			try{
				PageReference accPage = new PageReference('/' +accId);
      			accPage.setRedirect(true);
      			return accPage;
			//	return new pageReference('/' + accId);   This is another way of redirecting back to Account page
			//	P.setRedirect(true);
			}catch(Exception e){
				system.debug('===================BackButton Exception========' +e);
				}
		//	return new pageReference('/' + accId);
			return null;	
		}
}