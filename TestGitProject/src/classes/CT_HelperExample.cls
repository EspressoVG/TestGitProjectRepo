public class CT_HelperExample {
	public 	Application_Form__c  applicationFormInstance{get;set;}
	public Application_Form_Item__c  childInstance{get; set;}
	public List<WrapperClass> wrapClassList {get;set;}
	public CT_HelperExample(){
		wrapClassList = new List<WrapperClass>();
		applicationFormInstance = new Application_Form__c();
		for(Integer i=0; i<10; i++){
			WrapperClass wrapInstance = new wrapperClass();
			wrapClassList.add(wrapInstance);
		}
	}
	public class WrapperClass{
		Boolean flag; 
		public Application_Form_Item__c  childInstance{get; set;}
		public WrapperClass(){
			flag = false;
			childInstance = new Application_Form_Item__c();
		}
	} 
	public PageReference addMethod(){
		 
		WrapperClass wrapInstance = new wrapperClass();
		wrapClassList.add(wrapInstance);
		return null;
	} 
	public void saveMethod(){
		system.debug('==============applicationFormInstance.Id=============='+applicationFormInstance.Id);
		if(applicationFormInstance !=null){
			insert applicationFormInstance;
			Application_Form_Item__c childInstance = new Application_Form_Item__c();
			system.debug('==============childInstance.Application_Form__c=============='+childInstance.Application_Form__c);
			//childInstance.Application_Form__c = applicationFormInstance.Id ;
			system.debug('==============childInstance.Application_Form__c=============='+childInstance.Application_Form__c);
			List<WrapperClass> tempList = new List<WrapperClass>();
			if(wrapClassList != null && wrapClassList.size()>0){
				for(WrapperClass wc : wrapClassList){
					//wc.childInstance.Application_Form__c = childInstance.Application_Form__c;
					wc.childInstance.Application_Form__c = applicationFormInstance.Id;
					tempList.add(wc);
				}
				wrapClassList  = tempList ;
			}
		}
		system.debug('==============applicationFormInstance.Id=============='+applicationFormInstance.Id);	
	}
	public PageReference deleteMethod(){
		return null;
	}
}