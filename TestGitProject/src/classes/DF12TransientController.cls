public with sharing class DF12TransientController {

    // we keep the 'client' member variable as part of the viewstate,
    // because we want to track the state of something that we're attempting
    // to edit. all other variables are read-only on the VF page, so we
    // can make them 'transient' and remove them from viewstate. if you
    // want to see the difference made on the page's viewstate, remove the
    // 'transient' keyword from the 3 collections below and look at the
    // viewstate inspector from the dev footer.
    public Contact client { get; private set; }
    transient public List<Contact> connections { get; private set; }
    transient public List<Account> previousEmployers { get; private set; }
    transient public Set<String> hashTags { get; private set; }

    public DF12TransientController() {
        this.client = retrieveClient();
        this.connections = retrieveConnections();
        this.previousEmployers = retrievePreviousEmployers();
        this.hashTags = retrieveHashTags();
    }

    // just retrieve a sample contact ... any one will do
    private Contact retrieveClient() {
        return [
            SELECT
                Title,
                Phone,
                Name,
                MobilePhone,
                MailingStreet,
                MailingState,
                MailingPostalCode,
                MailingCountry,
                MailingCity,
                LastName,
                Id,
                HomePhone,
                FirstName,
                Email,
                Birthdate,
                AssistantPhone,
                AssistantName,
                AccountId
            FROM Contact
            LIMIT 1
        ];
    }

    // clearly, these aren't really 'connections' to the client above.
    // we just want some sample data to put on the page.
    private List<Contact> retrieveConnections() {
        return [
            SELECT Id, Name
            FROM Contact
            OFFSET 1
        ];
    }

    // dummy data
    private List<Account> retrievePreviousEmployers() {
        List<Account> a = new List<Account>();
        a.add(new Account(Name = 'GE'));
        a.add(new Account(Name = 'Siemens'));
        a.add(new Account(Name = 'EADS'));
        return a;
    }

    // dummy data
    private Set<String> retrieveHashTags() {
        Set<String> s = new Set<String>();
        s.add('#where');
        s.add('#dreamforce');
        s.add('#pto');
        s.add('#highlights');
        s.add('#bestpractice');
        s.add('#protip');
        s.add('#iwantapony');
        s.add('#hr');
        return s;
    }

    public void save() {
        try {
            insert client;
        } catch (Exception x) {
            client.addError(x.getMessage());
        }
    }

    @isTest
    private static void testGetMemberVariables() {
        List<Contact> c = new List<Contact>();
        c.add(new Contact(LastName = 'Smith1', FirstName = 'Joe1', Email = 'test@test.test.test.test'));
        c.add(new Contact(LastName = 'Smith2', FirstName = 'Joe2', Email = 'test@test.test.test.test'));
        insert c;
        DF12TransientController con = new DF12TransientController();
        System.assert(con.client != null, 'There should be a contact here.');
        System.assert(con.connections.size() > 0, 'There should be connections here.');
        System.assertEquals(3, con.previousEmployers.size(), 'There should be 3 employers here.');
        System.assertEquals(8, con.hashtags.size(), 'There should be 8 hashtags here.');
    }

}