public class picklistCheckController {
    public Trainer__c trainerObj{get;set;}
    public string bindField{
    get{ return 'Heya';}
    set;}
    
    /*
    public List<String> listString{
     get{
         return new List<String>{'Hello', 'Hi', 'Watsup'};
         //return tempList;
     }
     set;
   }
   */
   public List<String> listString{get;set;}
   
   public String stringList{
       get{
           String abc = 'Hello';
           abc = abc + 'Hi';
           abc +=  'Watsup';
       return abc;
       }
   }
     
    public picklistCheckController(){
        listString = new List<String>{'111', '222', '333', '444'};
        
    }
    
}