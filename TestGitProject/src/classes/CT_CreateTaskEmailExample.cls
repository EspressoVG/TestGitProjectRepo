/**
 * Email services are automated processes that use Apex classes
 * to process the contents, headers, and attachments of inbound
 * email.
 */
global class CT_CreateTaskEmailExample implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
		
		String myPlainText= '';
		
		
		try {
			if(email.plainTextBody.length() <= 255){
				myPlainText = email.plainTextBody;
			}else{
				myPlainText = email.plainTextBody.subString(0,254);
			}
      		Contact vCon = [SELECT Id, Name, Email FROM Contact	WHERE Email = :email.fromAddress LIMIT 1];
      		Task newTask = new Task();
      	  	newTask.Description =  myPlainText;
         	newTask.Priority = 'Normal';
          	newTask.Status = 'Inbound Email';
          	newTask.Subject = email.subject;
          	newTask.IsReminderSet = true;
          	newTask.ReminderDateTime = System.now()+1;
          	newTask.WhoId =  vCon.Id;
          	insert newTask;
          	System.debug('===========New Task Object: =========' + newTask ); 
           
           // to insert binary attachments
			if(email.binaryAttachments != null && email.binaryAttachments.size()>0){
				        system.debug('==============attachment==========');
				for (integer i = 0 ; i < email.binaryAttachments.size() ; i++) {
					Attachment attachment = new Attachment();
					attachment.ParentId = newTask.Id;
					attachment.Name = email.binaryAttachments[i].filename;
			        attachment.Body = email.binaryAttachments[i].body;
			        insert attachment;
			        system.debug('==============attachment=========='+attachment);
				}
			}
				
			// to insert text attachments
			if(email.textAttachments != null && email.textAttachments.size()>0){
				for(integer i = 0; i < email.textAttachments.size(); i++){
					Attachment attachment = new Attachment();
					attachment.ParentId = newTask.Id;
					attachment.Name = email.textAttachments[i].fileName;
					attachment.Body = Blob.valueOf(email.textAttachments[i].body);
					insert attachment;
				}
			}
				
	          /*
	           ==============ANOTHER Way of including attachments===============
	           for (Messaging.Inboundemail.TextAttachment tAttachment : email.textAttachments) {
				  Attachment attachment = new Attachment();
				  attachment.Name = tAttachment.fileName;
				  attachment.Body = Blob.valueOf(tAttachment.body);
				  attachment.ParentId = newTask.Id;
				  insert attachment;
			   }  
	    	 */
		} 
    	catch (QueryException e) {
       		System.debug('Query Issue: ' + e);
   		}
   		result.success = true;
        return result;
    }
}