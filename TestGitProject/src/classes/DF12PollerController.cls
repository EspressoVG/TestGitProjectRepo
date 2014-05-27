public with sharing class DF12PollerController {

    // in this example, the 'now' member variable must be part of the
    // page's viewstate, because I only want to display new accounts that
    // have been created after the page was initially loaded. every time
    // the page's actionPoller request comes in, the only way that the
    // controller will know the exact page load time is to serialize a
    // DateTime variable down to the browser.
    private DateTime now { get; set; }
    transient public List<Account> accounts { get; private set; }

    public DF12PollerController() {
        this.now = DateTime.now();
        this.accounts = new List<Account>();
    }

    public void find() {
        this.accounts = [
            SELECT Id, Name, CreatedDate
            FROM Account
            WHERE CreatedDate >= :this.now
        ];
    }

    @isTest
    private static void testFind() {
        DF12PollerController con = new DF12PollerController();
        System.assert(con.now != null, '\'now\' should not be null.');
        System.assert(con.accounts.size() == 0, '\'accounts\' should have zero records.');
        Account a = new Account(Name = 'Test Account');
        insert a;
        con.find();
        System.debug(con.accounts);
        System.assert(con.accounts.size() > 0, '\'accounts\' should have at least 1 record.');
    }

}