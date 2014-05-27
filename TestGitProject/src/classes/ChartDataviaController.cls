public class ChartDataviaController {

//----- get some Object data in here-----
	public ApexPages.StandardSetController setCon{
		get{
			if(setCon == null){
				setCon = new ApexPages.Standardsetcontroller(Database.getQueryLocator(
				[Select name,type, amount, closeDate From Opportunity]));
				setCon.setPageSize(5);
			}
			return setCon;
		}
		set;
	}
	
	//---Creating list of Opportunities Obj to get the records ----
	public List<Opportunity> getOpportunities(){
		return(List<Opportunity>) setCon.getRecords();
	} 
}