public class CT_OppCloneWithOliController {
 
    //added an instance varaible for the standard controller
    private ApexPages.StandardController controller {get; set;}
     // add the instance for the variables being passed by id on the url
    public Opportunity opp {get;set;}
 
    // initialize the controller
    public CT_OppCloneWithOliController(ApexPages.StandardController controller) {
 
        //initialize the stanrdard controller
        this.controller = controller;
        // load the current record
        opp = (Opportunity)controller.getRecord();
    }
 
    // method called from the VF's action attribute to clone the po
    public PageReference cloneWithOli() {
 
         // setup the save point for rollback
         Savepoint sp = Database.setSavepoint();
         Opportunity newOpp;
 
         try {
 
             opp = [Select o.Type, o.TrackingNumber__c, o.TotalOpportunityQuantity, o.StageName, o.Probability,
             		 o.Pricebook2Id, o.OwnerId, o.OrderNumber__c, o.NextStep, o.Name, o.MainCompetitors__c, o.LeadSource,
             		  o.IsWon, o.IsPrivate, o.IsDeleted, o.IsClosed, o.Id, o.HasOpportunityLineItem, o.ForecastCategoryName,
             		   o.ForecastCategory, o.FiscalYear, o.FiscalQuarter, o.Fiscal, o.ExpectedRevenue, o.Description, 
             		   o.DeliveryInstallationStatus__c, o.CurrentGenerators__c, o.CloseDate, o.CampaignId, o.Amount,
             		    o.AccountId From Opportunity o where Id = :opp.id];
             newOpp = opp.clone(false,true);
             insert newOpp;
 
 
             // copy over the partners - ONLY INCLUDE THE FIELDS YOU WANT TO CLONE
             List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
             for (OpportunityLineItem oliObj : [Select o.UnitPrice, o.SortOrder, o.ServiceDate, o.Quantity, o.PricebookEntryId, o.OpportunityId, o.ListPrice, o.IsDeleted, o.Description From OpportunityLineItem o where OpportunityId = :opp.id]) {
                  OpportunityLineItem newOliObj = oliObj.clone(false);
                  newOliObj.OpportunityId = newOpp.id;
                  oliList.add(newOliObj);
                  System.debug('=====================newOpp.id============' +newOpp.id);
             }
             insert oliList;
 
         } catch (Exception e){
             // roll everything back in case of errors
            Database.rollback(sp);
            ApexPages.addMessages(e);
            return null;
         }
        return new PageReference('/'+newOpp.id);
    }
}