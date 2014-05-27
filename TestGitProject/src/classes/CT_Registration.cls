/*
* @author : CloudTrigger LLC
* @descrption : This class will insert  the record for the custom object "registration" based upon the
                values input  by user in vf page
* @date : 03/16/2012
*/
public class CT_Registration{
    
    public string prodInterest{get;set;}
    public string leadSource{get;set;}
    public Registeration__c regInstance{get;set;}
    public List<selectOption> prodInterestList = new List<selectOption>();
    public List<selectOption> leadSourceList = new List<selectOption>(); 
    
    public CT_Registration(){
        regInstance = new Registeration__c();
    }
    
    /*
    * @author : CloudTrigger
    * @date : 03/16/2012
    * @description : Apex method for validating the field values  input by user on vf page
    * @parameters : Nothing 
    * @returns : Boolean msg
    */ 
    public Boolean pageNotValid (){
        Boolean msg = false;  
        if(regInstance.Name__c == null ){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR,'Name: You must enter a value'));
        }else if(regInstance.Age__c == 0){ 
            Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR,'Age: You must enter a value')); 
        }else if(regInstance.Product_Interest__c == null){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR,'Product Interest: You must enter a value'));    
        }else if(regInstance.Birthday__c == null){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR,'Birthdate: You must enter a value'));    
        }else if(regInstance.Phone__c == null){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR,'Phone: You must enter a value'));    
        }else if(regInstance.Email__c == null){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR,'Email: You must enter a value'));    
        }else{
            msg = true; 
        }    
        return msg;

    }

    /*
    * @author : CloudTrigger
    * @date : 03/16/2012
    * @description : Apex method for saving the record as input by user on vf page
    * @parameters : Nothing 
    * @returns : NULL PageReference
    */ 
    public PageReference saveMe(){
        if(pageNotValid()){            
           try{
               insert regInstance;
               Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.CONFIRM,'Registration Successful..!'));
               SendEmail(regInstance.Email__c);	               
            }catch(DMLException e){
                System.debug('======DMLException======='+e.getMessage());
            }                
        }
        return null;        
    }
    
    /*
    public void SendEmail(String Email)
    {
        //Messaging.reserveSingleEmailCapacity(2);  => This is not required
        Messaging.SingleEmailmessage mail = new Messaging.SingleEmailmessage();
        String[] toAddresses = new String[] {Email};
    //  mail.setToAddresses(toAddresses); 
        mail.setReplyTo('practicingsf@gmail.com');
   //   mail.setSubject('Your Account Information');
        mail.setBccSender(false);
        //Contact tempContact = new Contact();
        //tempContact.LastName = regInstance.Name__c;
        //tempContact.Email = regInstance.Email__c;
        //insert tempContact;
        //mail.setTargetObjectId(tempContact.Id);
        //mail.SetTemplateID('00X90000000y7Do');
        
    //  mail.setPlainTextBody('Your Account with ID: ' + regInstance.Id +' has been created.');
        
        Messaging.SendEmail(new Messaging.SingleEmailMessage[] {mail});
        //delete tempContact;
    } */
    
    public void SendEmail(String Email)
    {
    	String mailBody = '';
        List<EmailTemplate> emailTemplates = [Select e.Subject, e.Name, e.Body From EmailTemplate e 
        										where e.Name = 'Registration'];
        EmailTemplate emailTemplate = null;
        if(emailTemplates != null && emailTemplates.size() > 0) {
            emailTemplate = emailTemplates.get(0);
            mailBody = emailTemplate.Body;
        }
        Messaging.SingleEmailmessage mail = new Messaging.SingleEmailmessage();
        String[] toAddresses = new String[] {Email};
    	mail.setToAddresses(toAddresses); 
        mailBody = mailBody.replace('<LastName>', regInstance.Name__c);
        mail.setReplyTo('practicingsf@gmail.com');
        mail.setBccSender(false);
        mail.setPlainTextBody(mailBody);
        Messaging.SendEmail(new Messaging.SingleEmailMessage[] {mail});
    }       

}