trigger mp_DemoTrigger on Account (before insert, before update) {
	List<Account> accList = trigger.new;
	for(Account a : accList){
		if(trigger.isInsert){
			a.Description = String.valueOf(datetime.now());
		}
		
		if(trigger.isUpdate){
			a.Name = a.Name + '1';
		}
	}		
}