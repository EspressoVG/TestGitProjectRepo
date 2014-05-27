public class CT_RemainingContactsLookupPageController {
    public List<Contact> contList {get; set;}
    public String keyword {get; set;}
    public String prodForm {get; set;}
    public Integer countofRecord{get; set;}
    public String countofRecordStr{get; set;}
    public String accId {get; set;}
    public set<Id> contactsIdSet{get;set;}
    public boolean addflag{get;set;}
    public boolean ccFlag{get;set;}
    public boolean bccFlag{get;set;}
    public String strSelEmails;
	public List<String> lstEmails ;
    
    //--------------Constructor-----------------------------
    public CT_RemainingContactsLookupPageController()
	{
		if(system.currentPageReference().getParameters().get('selEmails') != null) {
            strSelEmails = system.currentPageReference().getParameters().get('selEmails');
        }
        
		lstEmails = new List<String>();
        if(strSelEmails!=null && strSelEmails!='')
        {
        	if(strSelEmails.indexOf(';')>0) 
        		lstEmails = strSelEmails.split(';');
        	else
        		lstEmails.add(strSelEmails);	
        }
	}
    //----------------Contact Related Methods----------------------------
    public void loadContactPage() {
    	countofRecordStr = null;
    	addflag = false;
    	ccFlag = false;
    	bccFlag = false;
    	
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
        
        if(system.currentPageReference() != null && system.currentPageReference().getParameters() != null && 
           system.currentPageReference().getParameters().get('addFlag') != null) {
            addFlag = boolean.valueof(system.currentPageReference().getParameters().get('addFlag'));
        }
        system.debug('------addFlag------' + addFlag);
        
        if(system.currentPageReference() != null && system.currentPageReference().getParameters() != null && 
           system.currentPageReference().getParameters().get('ccFlag') != null) {
            ccFlag = boolean.valueof(system.currentPageReference().getParameters().get('ccFlag'));
        }
        system.debug('------ccFlag------' + ccFlag);
        
        if(system.currentPageReference() != null && system.currentPageReference().getParameters() != null && 
           system.currentPageReference().getParameters().get('bccFlag') != null) {
            bccFlag = boolean.valueof(system.currentPageReference().getParameters().get('bccFlag'));
        }
        system.debug('------bccFlag------' + bccFlag);
        this.getContacts();
    }
    
    public void getContacts() {
        
        
        system.debug('------accId------' + accId);
        system.debug('------keyword------' + keyword);
        countofRecordStr = null;
        
        try {
            boolean is1000Plus = false;
            if(accId != null && accId != '' && accId != '000000000000000') {
            	if(keyword != null && keyword != '' ){
            		if(lstEmails.size()>0) {
                    	contList = [Select c.Name, c.Id, c.Account.Name, c.Email, c.AccountId From Contact c where c.AccountId = : accId and c.Name like :'%' + keyword + '%' and Email not in :lstEmails limit 1001];
            		} else {
            			contList = [Select c.Name, c.Id, c.Account.Name, c.Email, c.AccountId From Contact c where c.AccountId = : accId and c.Name like :'%' + keyword + '%' limit 1001];
            		}
            	}else{
            		if(lstEmails.size()>0) {
            			contList = [Select c.Name, c.Id, c.Account.Name, c.Email, c.AccountId From Contact c where c.AccountId = : accId and Email not in :lstEmails limit 1001];
            		}else{
            			contList = [Select c.Name, c.Id, c.Account.Name, c.Email, c.AccountId From Contact c where c.AccountId = : accId limit 1001];
            		}
            	}	
            	if(contList == null || contList.size() == 0) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No Contacts found for this Account'));
                }else {
                	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Below are your related contacts'));
            	}
            }else{
            	if(keyword != null && keyword != '' ){
            		if(lstEmails.size()>0) {
                    	contList = [Select c.Name, c.Id, c.Account.Name, c.Email, c.AccountId From Contact c where c.Name like :'%' + keyword + '%' and Email not in :lstEmails limit 1001];
            		} else {
            			contList = [Select c.Name, c.Id, c.Account.Name, c.Email, c.AccountId From Contact c where c.Name like :'%' + keyword + '%' limit 1001];
            		}
            	}else{
            		if(lstEmails.size()>0) {
            			contList = [Select c.Name, c.Id, c.Account.Name, c.Email, c.AccountId From Contact c where Email not in :lstEmails limit 1001];
            		}else{
            			contList = [Select c.Name, c.Id, c.Account.Name, c.Email, c.AccountId From Contact c limit 1001];
            		}
            	}	
            	if(contList == null || contList.size() == 0) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No Contacts found for this Account'));
                }
            }
             
            if(contList != null && contList.size() > 1000) {
                countofRecordStr = '1000+';
                if(accId != null && accId != '' && accId != '000000000000000') {
                	if(keyword != null && keyword != '') {
                		if(lstEmails.size()>0) {
                        	contList = [Select c.Name, c.Id, c.Account.Name, c.Email, c.AccountId From Contact c where c.AccountId = : accId and c.Name like :'%' + keyword + '%' and Email not in :lstEmails limit 1000];
                		} else {
                			contList = [Select c.Name, c.Id, c.Account.Name, c.Email, c.AccountId From Contact c where c.AccountId = : accId and c.Name like :'%' + keyword + '%' limit 1000];
                		}
                	}else{
                		if(lstEmails.size()>0) {
            				contList = [Select c.Name, c.Id, c.Account.Name, c.Email, c.AccountId From Contact c where c.AccountId = : accId and Email not in :lstEmails limit 1000];
            			}else{
            				contList = [Select c.Name, c.Id, c.Account.Name, c.Email, c.AccountId From Contact c where c.AccountId = : accId limit 1000];
            			}
                	}
            	}else{
            		if(keyword != null && keyword != '') {
                		if(lstEmails.size()>0) {
                        	contList = [Select c.Name, c.Id, c.Account.Name, c.Email, c.AccountId From Contact c where c.Name like :'%' + keyword + '%' and Email not in :lstEmails limit 1000];
                		} else {
                			contList = [Select c.Name, c.Id, c.Account.Name, c.Email, c.AccountId From Contact c where c.Name like :'%' + keyword + '%' limit 1000];
                		}
                	}else{
                		if(lstEmails.size()>0) {
            				contList = [Select c.Name, c.Id, c.Account.Name, c.Email, c.AccountId From Contact c where Email not in :lstEmails limit 1000];
            			}else{
            				contList = [Select c.Name, c.Id, c.Account.Name, c.Email, c.AccountId From Contact c limit 1000];
            			}
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