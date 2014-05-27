trigger mp_DeduplicateContacts on Contact (before insert, before update) {
	List<Contact> conList = trigger.new;
	List<Contact> conlist1 = new List<Contact>([Select c.Email from Contact c]);
	//List<Contact> dupConList = new List<Contact>();
	Set<String> emailSet = new Set<String>();
	Set<String> newRecordSet = new Set<String>();
	for(Contact c: conList1){
		emailSet.add(c.Email);
	}
	for(Contact c : conList){
		if(emailSet.contains(c.Email)){
			c.addError('Duplicate Email already exists');
			//dupConList.add(c);
		}
	}
	//delete dupConList;
}