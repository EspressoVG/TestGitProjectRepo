public class CT_SidebarSummary {
    //public List<Appointment__c> appList{get;set;}
    public list<Appointment__c> getappList(){
        return[select Appointment__c.Name, Appointment__c.Appointment_With__r.Name, Appointment__c.Time_of_meeting__c from Appointment__c
        where Time_of_meeting__c > :datetime.now() ORDER BY Appointment__c.Time_of_meeting__c ASC limit 5];
    }
        
        //public datetime myDateTime = datetime.now();
        
    public pageReference appointmentCounter(){  
    //  list<Appointment__c> appList = [select Appointment__c.Name, Appointment__c.Appointment_With__c, Appointment__c.Time_of_meeting__c from Appointment__c
    //  where Time_of_meeting__c > :datetime.now()];
        return null;
    }
}