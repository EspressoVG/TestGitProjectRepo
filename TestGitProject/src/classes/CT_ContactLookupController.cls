public class CT_ContactLookupController {
    public List<Contact> contList {get; set;}
    public String keyword {get; set;}
    public String prodForm {get; set;}
    public Integer countofRecord{get; set;}
    public String countofRecordStr{get; set;}
    public String accId {get; set;}
    
    
    //----------------Contact Related Methods----------------------------
    public void loadContactPage() {
    	countofRecordStr = null;
        if(system.currentPageReference() != null && system.currentPageReference().getParameters() != null && 
           system.currentPageReference().getParameters().get('accId') != null) {
            accId = system.currentPageReference().getParameters().get('accId');
        }
        system.debug('------accId------' + accId);
        
        if(system.currentPageReference() != null && system.currentPageReference().getParameters() != null && 
           system.currentPageReference().getParameters().get('keyword') != null) {
            keyword = system.currentPageReference().getParameters().get('keyword');
        }
        system.debug('------keyword------' + keyword);
        this.getContacts();
    }
    
    public void getContacts() {
        
        if(system.currentPageReference() != null && system.currentPageReference().getParameters() != null && 
           system.currentPageReference().getParameters().get('accId') != null) {
            accId = system.currentPageReference().getParameters().get('accId');
        }
        countofRecordStr = null;
        
        try {
            boolean is1000Plus = false;
            if(accId != null && accId != '' && accId != '000000000000000') {
            	if(keyword != null && keyword != '' ) {
                    contList = [Select c.Name, c.Id, c.Account.Name, c.Email, c.AccountId From Contact c where c.AccountId = : accId and c.Name like :'%' + keyword + '%' limit 1001];
            	} else {
            		contList = [Select c.Name, c.Id, c.Account.Name, c.Email, c.AccountId From Contact c where c.AccountId = : accId limit 1001];
            	}
            	if(contList == null || contList.size() == 0) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No Contacts found for this Account'));
                }
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select an Account first.'));
            }
            if(contList != null && contList.size() > 1000) {
                countofRecordStr = '1000+';
                if(accId != null && accId != '' && accId != '000000000000000') {
                	if(keyword != null && keyword != '') {
                        contList = [Select c.Name, c.Id, c.Account.Name, c.Email, c.AccountId From Contact c where c.AccountId = : accId and c.Name like :'%' + keyword + '%' limit 1000];
                	} else {
                		contList = [Select c.Name, c.Id, c.Account.Name, c.Email, c.AccountId From Contact c where c.AccountId = : accId limit 1000];
                	}
                }
                if(contList == null || contList.size() == 0) {
                	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No Contacts found for this Account'));
                }
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '1000+ records found, the search has been limited to 1000. Please enter search Criteria for more filtering the Contacts'));
            }
            if(contList != null && contList.size() > 0) {
                if(countofRecordStr == null) {
                    countofRecordStr = String.valueOf(contList.size());
                }
            }
        } catch(Exception e) {
            system.debug('------Exception------' + e);
        }
    }
    
   

}