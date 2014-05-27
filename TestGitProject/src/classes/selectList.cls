public class selectList{
    public String accId{get;set;}
    /*public List<selectOption> listSelectOption{
        get{
            List<Account> accList = new List<Account>();
            accList =  [Select Id, Name from account limit 5];
            system.debug('-----accList-----' + accList.size());
            if(accList != null){
            List<SelectOption> listSelectOption = new List<SelectOption>();
                for(Account a : accList){
                     
                     listSelectOption.add(new SelectOption(a.Id,a.Name));
                     system.debug('-----listSelectOption-----' + listSelectOption);
                     
                 }
             }
             return listSelectOption;
         }
         set;
     }*/
     
     public List<SelectOption> getlistSelectOption() {
            List<Account> accList = [Select Id, Name from account limit 5];
           // accList = 
            system.debug('-----accList-----' + accList.size());
            List<SelectOption> listSelectOptions = new List<SelectOption>();
            if(accList != null){
            
                for(Account a : accList){
                     
                     listSelectOptions.add(new SelectOption(a.Id,a.Name));
                     system.debug('-----listSelectOptions-----' + listSelectOptions);
                     
                 }
                 
             }
             return listSelectOptions;
    }
    
    public selectList(){
        system.debug('-----selectedValueInConstructor-----' + accId);
    } 
    
    public void showSelected(){
        system.debug('----selectedInShowSelected---' + accId);
    }
}