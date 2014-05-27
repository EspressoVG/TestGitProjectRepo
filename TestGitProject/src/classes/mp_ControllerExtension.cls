public class mp_ControllerExtension {
	private Account acc;
	private String accId;
	public List<Contact> conList;
	// The extension constructor initializes the private member
	// variable acct by using the getRecord method from the standard
	// controller.
	public mp_ControllerExtension(ApexPages.StandardController stdController){
		this.acc = (Account)stdController.getRecord();
		accId = acc.Id;
		//conList = [Select c.LastName, c.Name, c.Email, c.CreatedDate From Contact c where c.AccountId= :accId];
	}
	public Account getacc(){
		acc = [Select id, Name, Site, Industry, Autonumber_Check__c, CountOfContacts__c from Account where Id=: acc.Id];
		return acc;
	}
	
	public List<Contact> getconList(){
		conList = [Select c.LastName, c.Name, c.Email, c.CreatedDate From Contact c where c.AccountId= :accId];
		system.debug('------conList-----' +conList);
		return conList;
	} 
	public void setconList(List<Contact> conList){
		this.conList = conList;
	}	
	
	public Pagereference addCon(){
		conList.add(new contact(accountId=acc.id));
        system.debug('------conList1-----' +conList);
		return null;
	}	
	public Pagereference saveCon(){
		upsert conList;
		Pagereference p = new Pagereference('/'+accId);
		return p;
	}
}