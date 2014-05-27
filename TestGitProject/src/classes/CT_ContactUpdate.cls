//Changed
public class CT_ContactUpdate {
	public String accName{get;set;}
	public String contQuery;
	public List<Contact> contList;
	public List<contactWrapper> contWrapList{get;set;}
	public List<contactWrapper> searchedContList{get;set;}
	private Set<Account> accNameSet = new set<Account>([select a.Name, a.Id from Account a]);
	public List<selectOption> accList{get;set;}
	
	public CT_ContactUpdate(){
		accList = new List<selectOption>();
		accList.add(new selectOption('', '--none--'));
		for(Account a : accNameSet){
			accList.add(new selectOption(a.Name, a.Name));
		}
	}
	public class contactWrapper{
		public Boolean flag{get;set;}
		public Contact contInstance{get;set;}
		public contactWrapper(){
			flag = false;
			contInstance = new Contact();
		}
	}
	public void searchCont(){
		String accID;
		List<Account> accList1 = new List<Account>([select a.Id, a.Name from Account a where a.Name =: accName limit 1]);
		for(Account a : accList1){
			accID = a.Id;
		}
		contList = new List<Contact>([Select c.LastName, c.Id, c.FirstName, c.Email, c.AccountId From Contact c where AccountId =: accId]);
		//contQuery = 'Select c.LastName, c.Id, c.FirstName, c.Email, c.AccountId From Contact c where AccountId =: accId'
		searchedContList = new List<contactWrapper>();
		for(Contact c : contList){
			contactWrapper contWrap = new contactWrapper();
			contWrap.contInstance.LastName = c.LastName;
			contWrap.contInstance.FirstName = c.FirstName;
			contWrap.contInstance.Email = c.Email;
			searchedContList.add(contWrap);
		}
		
	}
	
	public void updateCont(){
		
	}
}