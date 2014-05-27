/*
* @author : CloudTrigger LLC
* @descrption : This class will search the records from the custom object "registration" based upon the
                values given by user in vf page
* @date : 03/16/2012
*/

public  class CT_regSearchDelete {
      public string PersonName{get;set;}
      public string prodInterest{get;set;}
      public string leadSource{get;set;}
      
      public List<Registeration__c> regDetailList{get; set;}
      public List<selectOption> prodInterestList = new List<selectOption>();
      public List<selectOption> leadSourceList = new List<selectOption>();
      
    

    /*
    * @author : CloudTrigger
    * @date : 03/16/2012
    * @description : Apex method for producing drop-down list of product-interest on vf page
    * @parameters : Nothing 
    * @returns : List<selectOption>prodInterestList
    */     
    public List<selectOption> getprodInterestList(){
        Set<String> prodInterestSet = new Set<String>();
        prodInterestList.add(new selectOption('', '-none-'));
        
        try{    
            for ( Registeration__c c : [Select r.Product_Interest__c, r.Id From Registeration__c r order by Product_Interest__c ]) {
                if(c.Product_Interest__c != null && c.Product_Interest__c !='')
                prodInterestSet.add(c.Product_Interest__c);
            }
        }catch(Exception e){
            system.debug('---------Exception--------'+e);
        }
        for(String prodIntStr: prodInterestSet) {
            prodInterestList.add(new selectOption(prodIntStr,prodIntStr));
        }
        
            return prodInterestList;
        }
        
    /*
    * @author : CloudTrigger
    * @date : 03/16/2012
    * @description : Apex method for producing drop-down list of lead-source on vf page
    * @parameters : Nothing 
    * @returns : List<selectOption>leadSourceList
    */       
    public List<selectOption> getleadSourceList(){
        Set<String> leadSourceSet = new Set<String>();
        leadSourceList.add(new selectOption('', '-none-'));
        try{
            for ( Registeration__c c : [Select r.Lead_Source__c, r.Id From Registeration__c r order by Lead_Source__c ]) {
                if(c.Lead_Source__c != null && c.Lead_Source__c != '')
                leadSourceSet.add(c.Lead_Source__c);
            }
        }catch(Exception e){
            system.debug('--------Exception------' +e);
        }
        for(String leadSrcStr: leadSourceSet) {
            leadSourceList.add(new selectOption(leadSrcStr,leadSrcStr));
        }
        
        return leadSourceList;
        }
    
    
    
    /*
    * @author : CloudTrigger
    * @date : 03/16/2012
    * @description : Apex method for searching records based upon the the value or selection made by user in VF page.
    * @parameters : Nothing 
    * @returns : Nothing 
    */ 
    public Pagereference searchMe(){
        
        String SOQL = ' Select Name__c, Age__c, Birthday__c,Phone__c, Product_Interest__c, Lead_Source__c, New_Customer__c From Registeration__c ';
        string condition = '';
        if(PersonName != null && PersonName != ''){
            if(condition != null && condition != '') {
            system.debug('-------condition-------------' + condition);
            condition += ' and Name__c like  \''+'%' + PersonName + '%'+'\'';
            }else{
               condition += ' where Name__c like  \''+'%' + PersonName + '%'+'\'';
               }
        }
        if(prodInterest != null && prodInterest != ''){
            if(condition != null && condition != '') {
                system.debug('-------condition-------------' + condition);
                condition += ' and Product_Interest__c = \'' + prodInterest + '\'';
                system.debug('-------condition-------------' + condition);
            } else {
                condition += ' where Product_Interest__c = \'' + prodInterest + '\'';
                }
        }
        if(leadSource !=null && leadSource != '') {
            if(condition != null && condition != '') {
                condition += ' and Lead_Source__c = \'' + leadSource + '\'';
            } else {
                condition += ' where Lead_Source__c = \'' + leadSource + '\'';
                }
        }
        
        if(condition != null && condition != ''){
            SOQL += condition;

        }
        system.debug('-------SOQL-------------' + SOQL);
        regDetailList = Database.query(SOQL);

        return null;
    }
    
    /*
    * @author : CloudTrigger
    * @date : 03/16/2012
    * @description : Apex method for deleting the selected record from the custom object "regsitration" through VF page.
    * @parameters : Nothing (If have parameters then use name of variable)
    * @returns : Nothing (If have parameters then use name of variable)
    */ 
    public void DeleteReg(){
        String strId;
        system.debug('=====str Id===='+Apexpages.currentPage().getParameters().get('objId'));
        if(Apexpages.currentPage().getParameters().get('objId')!=null 
            && Apexpages.currentPage().getParameters().get('objId')!='' )
        {
            strId = Apexpages.currentPage().getParameters().get('objId');
            system.debug('=====str Id===='+strId);
            List<Registeration__c> regList = new List<Registeration__c>([Select r.Product_Interest__c, r.Phone__c, r.Name__c, r.Lead_Source__c, r.Id, r.Age__c From Registeration__c r where r.id =: strId limit 1]);
            if(regList.size()>0)
            try{
                Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.Confirm,'Deletion Successful...!'));
                delete regList;
                }catch(DMLException e){
                system.debug('----------DMLException-----' +e);
            }
            searchMe();
        }
        
    }   

}