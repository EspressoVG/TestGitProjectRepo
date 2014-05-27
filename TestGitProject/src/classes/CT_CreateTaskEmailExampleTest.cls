@isTest
private class CT_CreateTaskEmailExampleTest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Test.startTest();
    	
    	Contact contObj = new Contact();
        contObj.LastName = 'abcTest';
        contObj.Email = 'test@test.com';
        insert contObj;
        // Create a new email and envelope object
        Messaging.InboundEmail email  = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        email.plainTextBody = 'This should become a note';
        email.fromAddress = contObj.Email;
        String contactEmail = 'aries.mishra@yahoo.com';
        email.subject = 'Dummy Account Name 123';
		Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
  		attachment.body = blob.valueOf('my attachment text');
 		attachment.fileName = 'textfile.txt';
 		attachment.mimeTypeSubType = 'text/plain';
 		
  		email.binaryAttachments =
    	new Messaging.inboundEmail.BinaryAttachment[] { attachment };
    	
    	Messaging.InboundEmail.TextAttachment attachment1 = new Messaging.InboundEmail.TextAttachment();
  		attachment1.body = String.valueOf('my attachment text');
 		attachment1.fileName = 'textfile1.txt';
 		attachment1.mimeTypeSubType = 'text/plain';
 		
  		email.textAttachments =
    	new Messaging.inboundEmail.TextAttachment[] { attachment1 };
 
         
        CT_CreateTaskEmailExample controller = new CT_CreateTaskEmailExample();
        
        Messaging.InboundEmailResult result = controller.handleInboundEmail(email, env);
        
        System.assert (result.success, 'InboundEmailResult returned a failure message');
        
		Test.stopTest();
    }
    
}