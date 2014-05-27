@RestResource(urlMapping='/FieldCase/*')
global with sharing class RESTCaseController {

@HttpPost   
  global static String createNewCase(String companyName, String caseType) {
     System.debug('COMPANY: '+companyName);
     System.debug('CASE TYPE: '+caseType);
     
     List<Account> company = [Select ID, Name, BillingState from Account where Name = :companyName];
     List<Contact> contactList;     
     if(company.size() > 0) {
        contactList = [SELECT ID, Name from Contact WHERE accountId = :company[0].Id LIMIT 1];
     }
     
     
     if(company.size() == 0 || contactList.size() == 0 ) {
        return 'No support data exists for this problem';
     }
     
     Case c = new Case();
     
     c.AccountId = company[0].Id;
     c.Subject = caseType + ' for '+companyName;
     c.Status = 'Open';
     insert c;
     
          
     return 'Submitted case to '+contactList[0].Name+' for '+companyName+'.  Confirmation sent to '+company[0].Name;
  }
  
  @HttpGet
  global Static List<Case> getOpenCases(){
      String companyName = RestContext.request.params.get('companyName');
      Account company = [Select Id, Name from Account where Name = :companyName];
      List<Case> cases = [SELECT Id, Subject, Status, OwnerId, Owner.Name from Case WHERE AccountId =: company.Id];
      return cases;
  }

}