trigger mp_DupContacts on Contact (before insert, before update) {
    map<String, Contact> conMap = new map<String,Contact>();
    for(Contact c : System.trigger.new){
        if(c.Email != null && (trigger.isInsert || c.Email != trigger.oldMap.get(c.Id).Email)){
            if(conMap.containsKey(c.Email)){ //c.Email == conMap.get(c.Email).Email
                c.Email.addError('Another new record exsits with same Email');
            }else{
                conMap.put(c.Email, c);
            }
        }
    }
    for(Contact c : [Select c.Email from Contact c where c.Email IN :conMap.KeySet()]){
        Contact con = conMap.get(c.Email);
        con.Email.addError('Record with same Email already exists');
    }
}