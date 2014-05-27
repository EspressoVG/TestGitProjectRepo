public class test_PageReferenceClass {
    public Blob b {get; set;}
	public test_PageReferenceClass(){
       methodCalled();
    } 
    public void methodCalled(){
    	PageReference p = Page.test_portal_VF;
        b = p.getContentAsPDF();
       	//return null;
    }
}