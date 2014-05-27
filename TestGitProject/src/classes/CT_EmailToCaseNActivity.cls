/**
* @author Vaibhav
* @date 25/10/2012
* @description Class: Email to case and activity class
*/

public class CT_EmailToCaseNActivity {
	public String accId{get;set;}
	public String emailStr{get;set;}
	public List<String> ownerEmailList;
	public String accName{get;set;}
	public Contact contactInstance{get;set;}
	
	public String contactEmailStr{get;set;}
	public String contactIdStr{get;set;}
	public String addToStr{get;set;}
	public String bccStr{get;set;}
	public String ccStr{get;set;}
	public String contactName{get;set;}
	public String addToName{get;set;}
	public String bccName{get;set;}
	public String ccName{get;set;}
	public String addToId{get;set;}
	public String ccId{get;set;}
	public String bccId{get;set;}
	public String subjectStr{get;set;}
	public String bodyStr{get;set;}
	
	public CT_EmailToCaseNActivity(){
		if(System.currentPageReference() != null &&
				System.currentPageReference().getParameters() != null &&
				System.currentPageReference().getParameters().get('accId') != null) {
					
				accId = (String) System.currentPageReference().getParameters().get('accId');
		}
		system.debug('----------accId----------' + accId);
		
		contactInstance = new Contact();
		List<Account> acclist;
    	List<User> userList;
		Set<Id> userIdSet;
		userIdSet = new set<Id>();
    	acclist  = [Select a.OwnerId, a.Name From Account a where a.id =: accId limit 1];
    	system.debug('----------acclist----------' + acclist);
    	if(acclist.size() > 0 && acclist != null){
	    	for(Account accObj : accList){
	    		userIdSet.add(accObj.OwnerId);
	    		accName = (String)accObj.Name;
		    	}
	    }
    	userList = [Select u.Email From User u where u.Id in : userIdSet limit 1];
    	system.debug('----------userList----------' + userList);
    	if(userlist.size() == 1 && userlist != null){
	    	for(User userObj : userlist){
	    		emailStr = (string)userObj.Email;
	    		
    		}
    	}		
    	system.debug('----------emailStr----------' + emailStr);
    	system.debug('----------accName----------' + accName);
    
	}
	/**
	* @author Vaibhav
	* @date 25/10/2012
	* @description Send Email Method
	* @param nothing 
	* @param 
	* @return 
	*/
	
	public void SendEmail()
    {
    	String mailBody = 'Congratulations '+ contactName + '!!!You are now a registered user.We will contact you soon .Thanks!';
       // List<EmailTemplate> emailTemplates = [Select e.Subject, e.Name, e.Body From EmailTemplate e 
       // 										where e.Name = 'Registration'];
      //  EmailTemplate emailTemplate = null;
     //   if(emailTemplates != null && emailTemplates.size() > 0) {
      //      emailTemplate = emailTemplates.get(0);
      //      mailBody = emailTemplate.Body;
      //  }
        Messaging.SingleEmailmessage mail = new Messaging.SingleEmailmessage();
        String[] toAddresses = new String[] {contactEmailStr};
        system.debug('=========toAddresses======='+toAddresses);
    	mail.setToAddresses(toAddresses); 
        //mailBody = mailBody.replace('<LastName>', contactName);
        mail.setReplyTo(emailStr);
        String[] bccAddresses = new String[] {bccStr};
        String[] ccAddresses = new String[] {ccStr};
        mail.setBccSender(false);
        mail.setCcAddresses(ccAddresses);
        mail.setBccAddresses(bccAddresses);
        mail.setSubject(subjectStr);
        mail.setPlainTextBody(mailBody);
        Messaging.SendEmail(new Messaging.SingleEmailMessage[] {mail});
        CreateCase();
    }
    
    public void CreateCase(){
    	Case newcase = new Case();
    	newCase.AccountId = accId;
    	newcase.ContactId = contactIdStr;
    	newcase.Status = 'New';
    	newcase.Origin = 'Web';
    	newcase.Subject = subjectStr;
    	newCase.Description = bodyStr;
    	insert newCase;
    	
    	Task[] newTask = new Task[0];
		try {
			//Contact vCon = [Select Id, Name, Email From Contact Where Email = :emailStr Limit 1];
			newTask.add(new Task(Description = bodyStr, Priority = 'Normal', Status = 'Inbound Email',Subject = subjectStr, IsReminderSet = true,
			ReminderDateTime = System.now()+1, WhoId = contactIdStr));
			insert newTask;
		}
		catch (System.QueryException e) {
		}
    	
    }

}