public with sharing class EmailHelper {

    public static void emailCustomerInvoices(String customerId) {

        String subject = 'Congratulations! You have successfully used @future! ';
        String body =
            'This email was generated by an Apex class that was called by ' +
            'another Apex method tagged with the @future annotation. Why is ' +
            'that cool? Well, in this example, we were simply sending an email, ' +
            'but what if you had some potentially very long-running process and ' +
            'you didn\'t want the user to wait for it to be completed? Yep, that\'s ' +
            'what @future does for you. Pretty neat, huh?';

        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

        email.setTargetObjectId(customerId);
        email.setSubject(subject);
        email.setPlainTextBody(body);
        email.setHtmlBody(body);
        emailList.add(email);

        Messaging.reserveSingleEmailCapacity(1);
        Messaging.SendEmailResult [] r = Messaging.sendEmail(emailList);

    }

}