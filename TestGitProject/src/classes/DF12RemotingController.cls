public with sharing class DF12RemotingController {

    @RemoteAction
    public static List<Contact> doSearch(String customerLastName) {
        // be careful when doing LIKE queries with '%' wildcards on both
        // sides of the query term, especially when using non-indexed
        // fields, as performance can suffer
        customerLastName = '%' + customerLastName + '%';
        return [
            SELECT Id, FirstName, LastName 
            FROM Contact 
            WHERE LastName LIKE :customerLastName 
            ORDER BY LastName, FirstName 
            LIMIT 200
        ];
    }

    @isTest
    private static void testDoSearch() {
        List<Contact> control = new List<Contact>();
        control.add(new Contact(LastName = 'Smith', FirstName = 'Joe1', Email = 'test@test.test.test.test'));
        control.add(new Contact(LastName = 'Smith', FirstName = 'Joe2', Email = 'test@test.test.test.test'));
        insert control;
        List<Contact> actual = DF12RemotingController.doSearch('Smith');
        System.assert(actual.size() == 2, 'There should be two contacts named Smith here.');
    }

}