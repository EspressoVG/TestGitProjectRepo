/*
* @author : CloudTrigger LLC
* @descrption : This class will search the Opportunities related to the selected Account from the Standard object "Opportunity" based upon the
                keyword input by the user in the SearchBox.
* @date : 03/20/2012
*/
public class CT_OppSearchController {
	private ApexPages.StandardController controller{get;set;}
//	private Account aObj;
	public String accStr;
//	public Opportunity oppO;
	public list<Opportunity> oppResultList {get;set;}
	public boolean bEditClicked{get;set;}
	
	public String searchText {
		get{
			if (searchText == null)
			searchText = 'Acme';
			return searchText;
		}
		set;	
	}
	public CT_OppSearchController(ApexPages.StandardController controller){
	//	this.controller = controller;
		bEditClicked = false;
	//	this.aObj = (Account)controller.getRecord();
	//	aObj = (Account)controller.getRecord();
		accStr = controller.getId();
		searchText = '';
		SearchMe();
	//	oppResultList = new List<Opportunity>();
	}
	
/*
* @author : CloudTrigger
* @date : 03/20/2012
* @description : Apex method for producing  list of Opprotunities based upon the keyword entered by the user for search.
* @parameters : Nothing 
* @returns : null
*/  
	public pageReference SearchMe(){
		String qry;
		if(searchText !=null && searchText != '')
			qry = 'Select o.Id, o.Name, o.StageName, o.CloseDate, o.Amount from Opportunity o Where AccountId =: accStr And o.Name LIKE \'%'+searchText+'%\' Order By o.Name';
	//		qry = 'Select o.Id, o.Name, o.StageName, o.CloseDate, o.Amount from Opportunity o Where AccountId = \''+aObj.Id+'\' And o.Name LIKE \'%'+searchText+'%\' Order By o.Name';
		else
			qry = 'Select o.Id, o.Name, o.StageName, o.CloseDate, o.Amount from Opportunity o Where AccountId =: accStr  Order By o.Name';
	//		qry = 'Select o.Id, o.Name, o.StageName, o.CloseDate, o.Amount from Opportunity o Where AccountId = \''+aObj.Id+'\'  Order By o.Name';
		system.debug('========Query String=======' + qry);
		oppResultList = Database.query(qry);
		return null; 
	}
	
/*
* @author : CloudTrigger
* @date : 03/20/2012
* @description : Apex method for saving the list of Opportunity records after the changes done by user on VF page itself .
* @parameters : Nothing 
* @returns : null
*/ 	
	public pageReference saveMe(){
		try{
		update oppResultList;
		}catch(Exception e){
			system.debug('========Exception====='+e);
		}
		bEditClicked = false;
		return null;
	}
/*
* @author : CloudTrigger
* @date : 03/20/2012
* @description : Apex method for cancelling the edit mode of  Opportunity records.
* @parameters : Nothing 
* @returns : null
*/	
	public void cancelMe(){
		bEditClicked = false;
	}
/*
* @author : CloudTrigger
* @date : 03/20/2012
* @description : Apex method for entering into the edit mode of  Opportunity records.
* @parameters : Nothing 
* @returns : null
*/	
	public void editMe() {
        //String editid = ApexPages.currentPage().getParameters().get('editid');
        //oppO = [Select o.Id, o.Name, o.StageName, o.CloseDate, o.Amount from Opportunity o where id=:editid];
        bEditClicked = true;
    }

}