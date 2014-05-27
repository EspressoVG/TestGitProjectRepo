public with sharing class DF12ActionController {

    public String customerLastName { get; set; }
    public List<Contact> searchResults { get; private set; }

    public void doSearch() {
        // be careful when doing LIKE queries with '%' wildcards on both
        // sides of the query term, especially when using non-indexed
        // fields, as performance can suffer
        customerLastName = '%' + customerLastName + '%';
        searchResults = [
            SELECT Id, FirstName, LastName 
            FROM Contact 
            WHERE LastName LIKE :customerLastName 
            ORDER BY LastName, FirstName 
            LIMIT 200
        ];
    }

    @isTest
    private static void testDoSearch() {
        Contact c = new Contact(LastName = 'Smith', FirstName = 'Joe');
        insert c;
        DF12ActionController con = new DF12ActionController();
        con.customerLastName = 'Smith';
        con.doSearch();
        System.assert(con.searchResults.size() > 0, 'Should have found at least one contact');
    }

}