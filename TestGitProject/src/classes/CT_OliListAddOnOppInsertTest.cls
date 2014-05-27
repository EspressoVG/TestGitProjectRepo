@isTest

public class CT_OliListAddOnOppInsertTest {
	private static List<Opportunity> oppList;
	
	static{
		oppList = new List<Opportunity>();	
		for(Integer i=0; i<999; i++){
		Opportunity opp1 = new Opportunity();
		opp1.Name = 'test1';
		opp1.CloseDate = Date.Today();
		opp1.StageName = 'Prospecting';
		oppList.add(opp1);
		}
/*		Opportunity opp2 = new Opportunity();
		opp2.Name = 'test1';
		opp2.CloseDate = Date.Today();
		opp2.StageName = 'Prospecting';
		opplist.add(opp2);   */
	}
	static testMethod void testCT_OliListAddOnOppInsert(){
		test.startTest();
			insert oppList;
		test.stopTest();	
	}

}