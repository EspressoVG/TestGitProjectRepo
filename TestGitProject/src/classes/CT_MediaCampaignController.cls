public class CT_MediaCampaignController {
	public Media_Campaign__c mcInstance{get; set;}
	public String strId{get;set;}
	public String retURL{get;set;}
	public List<Interview_Pitches__c> lstPitches = new List<Interview_Pitches__c>();
	public List<Interview_Pitches__c> results = new List<Interview_Pitches__c>();
	public List<selectOption> statusList = new List<selectOption>();
	public String status{get;set;}
	public Integer selIntPitchCount{get;set;}
	public List<pitchesHelper> pitchesHelperList{get;set;}
	public String SOQL;
	public Map<Id, Interview_Pitches__c> selectedPitchesMap;
	
	//--------------Variables for pagination--------
	public ApexPages.Standardsetcontroller pager;
	
	private Integer pageSize = 5;
    private Boolean hasPrevious = false;
    private Boolean hasNext = false;
    private Integer pageNumber = 0;
    private Integer totalPages = 0;
	
	//--------------Constructor---------------
	public CT_MediaCampaignController(ApexPages.StandardController controller){
		//strId = stdController.getId();
		selectedPitchesMap = new Map<Id, Interview_Pitches__c>();
		strId = ApexPages.currentPage().getParameters().get('Id') ;
		retURL  = ApexPages.currentPage().getParameters().get('retURL') ;
		if(strId != null && strId != ''){
			mcInstance = [Select m.SystemModstamp, m.Projected_Reach__c, m.OwnerId, m.Name, m.LastModifiedDate, m.LastModifiedById, m.LastActivityDate, m.IsDeleted, m.Id, m.CreatedDate, m.CreatedById, m.ConnectionSentId, m.ConnectionReceivedId From Media_Campaign__c m where Id =: strId];
			searchPitches();
		}
		
		selIntPitchCount = 0;
    	//selectedPitchesMap.clear();
	}
	
	//---------------Foormation of Status Picklist--------------
	public List<selectOption> getstatusList(){
		statusList.add(new selectOption('' , '--All--'));
		List<Interview_Pitches__c> tempList = new List<Interview_Pitches__c>([Select i.Status__c, i.Name, i.Media_Campaign__c, i.Id From Interview_Pitches__c i order by Status__c]);
		Set<String> tempset = new Set<String>();
		for(Interview_Pitches__c ipObj : tempList){
			tempset.add(ipObj.Status__c);
		}
		for(String StrStatus: tempset ){
				statusList.add(new selectOption(StrStatus , StrStatus));
		}
		return statusList ;
	}
	
	public void countSelected()
    {
    	
    	if(pitchesHelperList!=null && pitchesHelperList.size()>0)
    	{
    		for(pitchesHelper oPitch : pitchesHelperList)
    		{
    			if(oPitch.flag){
    				if(selectedPitchesMap.containsKey(oPitch.Id)){
    					continue;	
    				}
    				selIntPitchCount++;
    				selectedPitchesMap.put(oPitch.Id, oPitch.intPitch);
    			} else{
    				if(selectedPitchesMap.containsKey(oPitch.Id)){
    					selectedPitchesMap.remove(oPitch.Id);
    					selIntPitchCount--;
    					if(selIntPitchCount <= 0){
    						selIntPitchCount = 0;
    					}
    				}
    			}	
    		}
    	}
    }
	
	public void searchPitches(){
		selIntPitchCount = 0;
		selectedPitchesMap.clear();
		SOQL = 'Select i.Status__c, i.Name, i.Media_Campaign__c, i.Id, i.Region__c From Interview_Pitches__c i  ';
		string condition = '';
		system.debug('============condition================'+condition);
		if(status != null && Status != ''){
			if(condition != null && condition != '') {
				condition += ' and Status__c = \'' + status + '\' and Media_Campaign__c = \'' +strId+ '\'' ;
			} else {
			    condition += ' where Status__c = \'' + status + '\' and Media_Campaign__c = \'' +strId+ '\' ';
	        }
	    } else{
	    	if(condition != null && condition != '') {
				condition += ' and Media_Campaign__c = \'' +strId+ '\'' ;
			} else {
			    condition += ' where Media_Campaign__c = \'' +strId+ '\' ';
	        }
	    }
	    system.debug('============================condition=================='+condition);
	    if(condition != null && condition != ''){
			SOQL += condition;
		}
		
		system.debug('============================SOQL=================='+SOQL);
	   // pitchesList = new List<Interview_Pitches__c>();
	    if(SOQL != null){
		    pager = new ApexPages.Standardsetcontroller(Database.getQueryLocator(SOQL));
	     	pager.setPageSize(pageSize);
	     	lstPitches = (List<Interview_Pitches__c>)pager.getRecords();
	    }
	    if(lstPitches != null && lstPitches.size() > 0){
	    	loadPage();
	    }
	}
	
	//---------------Pagination Logic Starts--------------------------
	public void previous() {
	        pager.previous();
	        lstPitches = new List<Interview_Pitches__c>();
			lstPitches = (List<Interview_Pitches__c>)pager.getRecords();
	        loadPage();
    }

    public void next() {
        	pager.next();
        	lstPitches = new List<Interview_Pitches__c>();
			lstPitches = (List<Interview_Pitches__c>)pager.getRecords();
	        loadPage();
    }
    
    public void loadPage(){
			pitchesHelperList = new List<pitchesHelper>();
	        if(lstPitches != null && lstPitches.size() > 0) {
				for(Interview_Pitches__c ipObj: lstPitches) {
						pitchesHelper helper = new pitchesHelper();
						helper.intPitch = ipObj;
						helper.Name = ipObj.Name;
						helper.id = ipObj.Id;
						helper.status = ipObj.Status__c;
						helper.region = ipObj.Region__c;
						helper.mediaCampaign = ipObj.Media_Campaign__c;
						if(selectedPitchesMap.containsKey(ipObj.Id)){
							helper.flag = true;
						} else{
							helper.flag = false;
						}
						
						pitchesHelperList.add(helper);
						system.debug('======================pitchesHelperList============='+pitchesHelperList);
				}
	        }
    }
    
     
    
    
    public Boolean getHasNext(){
        if(pager != null){
            hasNext = pager.getHasNext();
            system.debug('============================has next======================='+hasNext);
        }
        return hasNext;
    }
    
    public Boolean getHasPrevious(){
        if(pager != null){
            hasPrevious = pager.getHasPrevious();
            system.debug('============================has Previous======================='+hasPrevious);
        }
        return hasPrevious;
    }
    
    public Integer getPageNumber(){
        if(pager != null)
        {
            pageNumber = pager.getPageNumber();
            system.debug('============================pageNumber======================='+pageNumber);
        }
        return pageNumber;
    }
    
    public Integer getTotalPages(){
        if(pager != null) {
            Integer total = 0;
            if(Math.mod(pager.getResultSize(), pageSize) > 0){
                total = (pager.getResultSize()/pageSize) + 1;
            }else{
                total = pager.getResultSize()/pageSize;
            }
            
            totalPages = total;
        }
        system.debug('============================totalPages======================='+totalPages);
        return totalPages;
    }
    
   
    
    
    //Pagination Logic Ends
	
	public PageReference saveMethod(){
		PageReference p;
		upsert mcInstance;
		p = new Pagereference('/' + mcInstance.Id);
		p.setRedirect(true);
		return p;
	}
	
	public Pagereference cancelMethod(){
		return new Pagereference('/' + retURL);
	}
	
	public class pitchesHelper {
		public Interview_Pitches__c intPitch{get;set;}
		public boolean flag {get; set;}
        public String Name {get; set;}
        public String id {get; set;}
        public String status{get;set;}
        public String mediaCampaign {get;set;}
        public String region {get; set;}
        
        public pitchesHelper() {
            flag = false;
        }
    }
}