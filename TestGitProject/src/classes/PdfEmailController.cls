public with sharing class PdfEmailController {
	public ID accountId{get;set;}
	public String email{get;set;}
	
	public List<SelectOption> accounts{
		get{
			if(accounts ==  null){
				accounts = new List<SelectOption>();
				accounts.add(new SelectOption('0019000000BAD9R', 'Burlington Textiles Corp of America'));
				accounts.add(new SelectOption('0019000000BAD9N', 'GenePoint'));
			}
			return accounts;
		}
		set;
	}
	
	public PageReference sendPdf(){
		PageReference pdf = Page.pdfGeneratorTemplate;
		//add account to the parameters of the page having statndard controller
		pdf.getParameters().put('id', accountId);
		
		Blob body; 
		try{
			//returns the output of page as PDF
			body = pdf.getContentAsPDF();
			
		} catch(VisualforceException e){
			body = Blob.valueOf('VisualForce Exception' +e);
		}
		
		Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
		//attach.getContentType('application/pdf');
		attach.setFileName('testPdf.pdf');
		//attach.setInline(false);
		attach.Body = body;
		
		Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
		mail.setUseSignature(false);
		mail.setToAddresses(new String[]{email});
		mail.setSubject('Test Mail Subject');
		mail.setHtmlBody('Here is the email you requested . Check the Attachment!');
		mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });
		
		//send the Email
		Messaging.sendEmail(new Messaging.Singleemailmessage[]{mail}, true);
		
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Email with PDF sent to ' + email));
		return null;
	}
}