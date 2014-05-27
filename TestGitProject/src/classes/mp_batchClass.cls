global class mp_batchClass implements Database.Batchable<sObject>{
	global final String query;
    global final string field;
    global final string value;
    global mp_batchClass(String q, String f,String v){
        query = q;
        field = f;
        value = v;
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<sObject> listAccount){
        for(sObject s : listAccount){
            s.put(field,value);
        }
        Database.SaveResult[] result = Database.Update(listAccount);
        //update listAccount;
   }    
   global void finish(Database.BatchableContext BC){ 
   }     
}