@isTest
	private class CT_TestAccSeqNoCustBookNameTrigger {
		static testMethod void myUnitTest() {
			test.startTest();
			List<Account> accList = new List<Account>();
			for(integer i=0; i<300 ; i++){
				Account accObj = new Account();
				accObj.Name = 'Testing';
				accList.add(accObj);
			}
			insert accList;
			test.stopTest();
		}
		static testMethod void myTest() {
			test.startTest();
			List<Account> accountList = new List<Account>();
			for(integer i=0; i<300 ; i++){
				Account accObj = new Account();
				accObj.Name = 'Test';
				accountList.add(accObj);
			}
			insert accountList;
			test.stopTest();
		}
}