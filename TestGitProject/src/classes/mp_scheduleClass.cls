global class mp_scheduleClass implements Schedulable{
    String query = 'Select Id from Account';
    global void execute(SchedulableContext sc){
        mp_batchClass b = new mp_batchClass(query, 'Industry', 'Chemical');
        database.executebatch(b);
    } 
}