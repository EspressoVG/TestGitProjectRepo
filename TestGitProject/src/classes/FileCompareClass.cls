public with sharing class FileCompareClass {
	
	public String strName{get; set;}
	public transient blob file{get;set;}
    public transient string fileName{get;set;}
    public transient blob file1{get;set;}
    public transient string fileName1{get;set;}
    public transient String contentType{get;set;}
    public Appointment__c appObj{get; set;}
    
    public transient Attachment attach {get;set;}
    public transient Attachment attach2 {get;set;}
    public transient Attachment att{get; set;}
    public String strId;
    
    public FileCompareClass(){
    	appObj = new Appointment__c();
    	
    }
	
	public void uploadMethod(){
		if(strName != null){
			appObj = [Select a.Time_of_meeting__c, a.SystemModstamp, a.OwnerId, a.Name, a.LastModifiedDate, a.LastModifiedById, a.LastActivityDate, a.IsDeleted, a.Id, a.CreatedDate, a.CreatedById, a.ConnectionSentId, a.ConnectionReceivedId, a.Appointment_With__c From Appointment__c a WHERE Name =: strName limit 1];		
			System.debug('=====appObj from SOQL======'+appObj.Name);
			System.debug('=====appObj from SOQL======'+appObj.Id);
			if(appObj == null || appObj.Id == null){
				appObj = new Appointment__c(Name = strName);
				try{
					insert appObj;
				}catch(Exception e){
					System.debug('=====Exception======'+e);
				}
				
			}
			
		}
		System.debug('=====appObj Name======'+appObj.Name);
		System.debug('=====appObj ID========'+appObj.Id);
		System.debug('========log-=========='+file);
		System.debug('=====contentType======'+contentType);
		if(fileName!=null && file!=Null){
			System.debug('==============hiiii=========='+fileName);
            attach = new Attachment(parentId = appObj.id, name=fileName, body = file, ContentType = 'text/plain ; charset= UTF-8');
            insert attach;
        }
        if(fileName1!=null && file1!=Null){
			System.debug('==============hiiii=========='+fileName1);
            attach2 = new Attachment(parentId = appObj.id, name=fileName1, body = file1, ContentType = 'text/plain ; charset= UTF-8');
            insert attach2;
        }
        String blob2;
        try{
        	blob2 = EncodingUtil.base64Encode(attach2.body);
        	system.debug('====blob2=====' +blob2);
        }catch(Exception e){
        	system.debug('====blob2 Exception=====' +e);
        }
        system.debug('====attach2 Body=====' +attach2.body);
     	system.debug('====attach2 Name=====' +attach2.Name);
        
        
        att = [SELECT Id, ParentId, body, Name FROM Attachment WHERE ParentId =: appObj.Id AND Name =:  fileName];
        system.debug('====appObj.Id====' +appObj.Id);
        system.debug('====attachment Body====' + att.body);
        String bodyContent;
        String encodedBlob;
        try{
        	encodedBlob = EncodingUtil.base64Encode(att.body);
        	system.debug('====encodedBlob String=====' +encodedBlob);
        }catch(Exception e){
        	system.debug('====Encoded Blob Exception=====' +e);
        }
        system.debug('====attachment body after encoding=====' +EncodingUtil.base64Encode(att.body));
        system.debug('=====attachment after decoding====='+EncodingUtil.base64Decode(EncodingUtil.base64Encode(att.body)));
        try{
        	system.debug('====attachment Body In String====' + att.body.toString());
        }catch(Exception e){
        	System.debug('=====Exception======'+e);
        }
        
	}
	
}