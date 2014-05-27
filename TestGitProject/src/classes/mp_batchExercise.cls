public class mp_batchExercise {
	String query = 'Select Id from Account';
    public Account a{get;set;}
    public mp_batchExercise(){
       a = new Account();
    }    
    public Pagereference updateAction(){
   	 mp_batchClass newObj = new mp_batchClass(query, 'Industry', a.Industry);
     ID batchprocessid = Database.executeBatch(newObj, 5);
     return null;   
    }     
}