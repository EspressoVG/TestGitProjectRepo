public class RESTController{
    public String token{set; get;}
    public String uname{set; get;}
    public String password{set; get;}
    
    public String rootResult{set; get;}
    public String service1{set; get;}
    public String service2{set; get;}
    public String service3{set; get;}
    public String service4{set; get;}
    public String listsize{set; get;}
    
    public List<String> queryList{set; get;}
    
    private boolean s1 = true;
    private boolean s2 = true;
    private boolean s3 = true;
    private boolean s4 = true;
    private boolean s5 = true;
    private boolean s6 = true;
    public Set <String> parsestring = new Set<String>();
    
    public String queryResult{set; get;}
    public String inpQuery{set; get;}
    public String inpObject{set; get;}
    public String objResult{set; get;}
    public String rootResultSet{set; get;}
    
    public boolean getS1(){
    	system.debug('-----s1---' + s1);
        return s1;
    }
    public boolean getS2(){
    	system.debug('-----s1---' + s1);
        return s2;
    }
    public boolean getS3(){
        return s3;
    }
    public boolean getS4(){
        return s4;
    }
    public boolean getS5(){
        return s5;
    }
    public boolean getS6(){
        return s6;
    }

    public PageReference login() {
    
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();

        req.setEndpoint('https://ap1.salesforce.com/services/oauth2/token');
        req.setMethod('POST');
        req.setBody('grant_type=password&client_id=3MVG9Y6d_Btp4xp6LSpr8NuyfxPuL4LZlf_bjyjSF2Aekcj6sI7CyFzJFKIHrXl3tb_oNFtGtN2GsHI3guYT5&client_secret=5266262482773056686&username='+uname+'&password='+password+'&format=json'); 
        
        // Invoke web service call
        String result = '';        
            
        try {
            res = http.send(req);
            result = res.getBody();
            
            Integer indx = result.lastIndexOf(':');
            Integer lstIndx = result.length();
            String temp = result.subString(indx+2,lstIndx-2);
            token = temp;
            
        } catch(System.CalloutException e) {
            System.debug('Callout error getAccessToken: '+ e);
            System.debug(res.toString());
        }                  
        System.debug('res***************** >>> '+res);
        System.debug('result***************** >>> '+result);
        System.debug('token ***************** >>> '+token);
        //return null;
        PageReference pnew = Page.RestDemo2;
        pnew.getParameters().put('token',token);
         if(token!= null){
             
             pnew.setRedirect(false);
             return pnew;
         }
         else       
             return null;
    }
        public PageReference searchObject(){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        String result = '';  
        List <string> keys = new List<String>();
         String result1;
            String result2;
            String result3;
        if(inpObject!= null){
            req.setEndpoint('https://ap1.salesforce.com/services/data/v24.0/sobjects/'+inpObject);
            req.setMethod('GET');
            String authVal = 'OAuth '+token;
            req.setHeader('Authorization',authVal);
            
        }
        else{
            req.setEndpoint('https://ap1.salesforce.com/services/data/v24.0/sobjects');
            req.setMethod('GET');
            String authVal = 'OAuth '+token;
            req.setHeader('Authorization',authVal);
            //String result = '';  
        }      
            
        try {
            res = http.send(req);
            result = res.getBody();
            
            
        } catch(System.CalloutException e) {
            System.debug('Callout error callQuery: '+ e);
            System.debug(res.toString());
        }  
        
        objResult = result;
        rootResultSet = result;
        s5 = true;
        System.debug('queryResult ***************** >>> '+objResult);
        return null;
        
    }  
    
     public PageReference showRecentItems() {
    
        String queryString = inpQuery.replace(' ','+');
        System.debug('inpQuery*************** >> '+inpQuery);
        System.debug('queryString *************** >> '+queryString);
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();

       
        req.setEndpoint('https://ap1.salesforce.com/services/data/v24.0/recent');
        
        req.setMethod('GET');
        String authVal = 'OAuth '+token;
        req.setHeader('Authorization',authVal);
               
        // Invoke web service call
        String result = '';        
            
        try {
            res = http.send(req);
            result = res.getBody();
            System.debug('result is  >>>>>>'+ result);
       
            
        } catch(System.CalloutException e) {
            System.debug('Callout error callQuery: '+ e);
            System.debug(res.toString());
        }  
        
        queryResult = result;
        rootResultSet = result;
        s5 = true;
        System.debug('queryResult ***************** >>> '+queryResult);
        return null;
     
    }
    
    public void root() {
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();

        req.setEndpoint('https://ap1.salesforce.com/services/data/v24.0');
        //req.setEndpoint('https://ap1.salesforce.com/services/oauth2/token/data/v24.0');
        req.setMethod('GET');
        System.debug('Token in root() - '+token);
        String authVal = 'OAuth '+token;
        req.setHeader('Authorization',authVal);
        
        // Invoke web service call
        String result = '';        
            
        try {
            System.debug('Before -- ');
            res = http.send(req);
            result = res.getBody();
            System.debug('After -- ');
            System.debug('After--result---- ' + result);
            System.debug('token---- ' + token);
            
        } catch(System.CalloutException e) {
            System.debug('Callout error callRoot: '+ e);
            System.debug(res.toString());
        }  
        List<String> pstring = new List<String>();
        
        
        JSONParser parser = JSON.createParser(result);
	            
	                while (parser.nextValue() != null) {
	                	System.debug('Current toke--->: ' + parser.getCurrentName());
	                	System.debug('Current val--->: ' + parser.getText());
	                }
	            
	        
        
        
        /*
        rootResult = result;
        JsonParsing.dataCommand dataCommandObj = new JsonParsing.dataCommand(rootResult);
        JSONObject jobject1 = new JSONObject(jobject);
        parsestring = jobject1.keys();
        pstring.addAll(parsestring);
        System.debug('list is>>>>>>'+ pstring);
        if(pstring.size()>0){
            service1 = jobject1.getString(pstring[0]);
            service2 = jobject1.getString(pstring[1]);
            service3 = jobject1.getString(pstring[2]);
            service4 = jobject1.getString(pstring[3]);
            
        }
        
        if(service1 != null)
            s1 = true;
        if(service2 != null)
            s2 = true;
        if(service3 != null)
            s3 = true;
        if(service4 != null)
            s4 = true;
        
        return null; */
            
    }
    

 
}