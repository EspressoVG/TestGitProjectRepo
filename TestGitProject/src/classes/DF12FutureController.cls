public with sharing class DF12FutureController {

    public Contact customer {
        get {
            return [
                SELECT Id, FirstName, LastName, Email
                FROM Contact
                WHERE Id = :ApexPages.currentPage().getParameters().get('id')
                LIMIT 1
            ];
        }
        private set;
    }

    public PageReference createSampleContactIfNecessary() {
        if (ApexPages.currentPage().getParameters().get('id') == null) {
            Contact c = new Contact();
            User currentUser = [
                SELECT Id, FirstName, LastName, Email
                FROM User
                WHERE Id = :UserInfo.getUserId()
            ];
            List<Contact> cList = [
                SELECT Id, FirstName, LastName, Email
                FROM Contact
                WHERE Email = :currentUser.Email
            ];
            if (cList != null && cList.size() > 0) {
                c = cList[0];
            } else {
                c.FirstName = currentUser.FirstName;
                c.LastName = currentUser.LastName;
                c.Email = currentUser.Email;
                insert c;
            }
            PageReference pr = ApexPages.currentPage().setRedirect(true);
            pr.getParameters().put('id', c.id);
            return pr;
        }
        return null;
    }

    @RemoteAction
    public static String requestAllInvoices(String customerId) {
        sendAllInvoices(customerId);
        return 'All invoices have been requested.';
    }

    @future
    private static void sendAllInvoices(String customerId) {
        EmailHelper.emailCustomerInvoices(customerId);
    }

    @isTest
    private static void testCreateSampleContactIfNecessary() {
        DF12FutureController con = new DF12FutureController();
        PageReference pr = Page.DF12Future;
        Test.setCurrentPageReference(pr);
        con.createSampleContactIfNecessary();
        System.assertEquals(1, ApexPages.currentPage().getParameters().size(), 'Page should have the id param.');
    }

    @isTest
    private static void testRequestAllInvoices() {
        Contact c = new Contact(LastName = 'Smith', FirstName = 'Joe', Email = 'test@test.test.test.test');
        insert c;
        String response = DF12FutureController.requestAllInvoices(c.id);
        System.assertEquals('All invoices have been requested.', response, 'The wrong response was returned.');
    }

    @isTest
    private static void testGetCustomer() {
        DF12FutureController con = new DF12FutureController();
        PageReference pr = Page.DF12Future;
        Test.setCurrentPageReference(pr);
        con.createSampleContactIfNecessary();
        System.assertEquals(con.customer.Id, ApexPages.currentPage().getParameters().get('id'), 'Customer retrieved was not correct.');
    }

}