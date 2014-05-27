@isTest
private class mp_DemoTestClass {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Account a = new Account(Name = 'test11');
        insert a;
        a = [select Name, Id from Account where Id = :a.Id];
        system.assertEquals('test11', a.Name);
    }
}