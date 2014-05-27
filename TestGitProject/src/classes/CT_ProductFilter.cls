public class CT_ProductFilter {
	public String inputKeyword{get;set;}
	public String prodTypeOrName{get;set;}
	public List<selectOption> prodPickList{get; set;}
	public List<ProdHelper> searchedProdListHelper{get;set;}
	public List<ProdHelper> addProdHelperList{get;set;}
	public Boolean prodFlag {get;set;}
	public set<String> selectedHelperIdSet;
	public List<String> remainingProductsIdsList;
	public String innerQuery;
	public Boolean searchFlag {get;set;}
	public Boolean addFlag {get;set;}
	
	public CT_ProductFilter(){
		prodPickList = new List<SelectOption>();
		prodPickList.add(new SelectOption('','--None--'));
		prodPickList.add(new SelectOption('Product Code','Product Code'));
		prodPickList.add(new SelectOption('Product Name','Product Name'));
		addProdHelperList = new List<ProdHelper>();
		selectedHelperIdSet = new set<String>();
		remainingProductsIdsList = new List<String>();
		searchFlag = false;
		addFlag = false;
		prodFlag = false;
	}
	
	public void remainingProd(){
		if(remainingProductsIdsList.size() > 0 && remainingProductsIdsList != null){
			innerQuery = '(';
			system.debug('=============innerQuery===========' +innerQuery);
			system.debug('=============remainingProductsIdsList.size()===========' +remainingProductsIdsList.size());
			for(Integer i=0 ; i < remainingProductsIdsList.size(); i++){
				if(i == 0){
					innerQuery += '\'' +remainingProductsIdsList.get(i)+ '\'';
				}else{
					innerQuery += ', \''+remainingProductsIdsList.get(i)+ '\'';
				}
			}
			innerQuery += ')';
			system.debug('=============innerQuery===========' +innerQuery);
		}
	}
	public void searchProduct(){
		List<Product2> searchedProdList = new List<Product2>();
		String prodQuery = 'Select p.SystemModstamp, p.ProductCode, p.Name, p.LastModifiedDate, p.LastModifiedById, p.IsDeleted, p.IsActive, p.Id, p.Family, p.Description, p.CreatedDate, p.CreatedById, p.ConnectionSentId, p.ConnectionReceivedId From Product2 p';
		if(inputKeyword != null && inputKeyword != ''){
			if(prodTypeOrName == 'Product Name'){
				prodQuery +=  ' where p.Name like \'%'+inputKeyword+'%\'';
			}if(prodTypeOrName == 'Product Code'){
				prodQuery += ' where p.ProductCode like \'%'+inputKeyword+'%\'';
			}
	 
			if(innerQuery != null && innerQuery != ''){
				prodQuery += ' and p.Id NOT IN ' +innerQuery;
			}
		}else{
			if(innerQuery != null && innerQuery != ''){
				prodQuery += ' where p.Id NOT IN ' +innerQuery;
			}
		}
			prodQuery += ' limit 100';
		
		system.debug('====prodQuery======' +prodQuery);
		if(prodQuery != null && prodQuery != ''){
			searchedProdList = Database.query(prodQuery);
		}
		system.debug('============================searchedProdList=============================' +searchedProdList);
		
		if(searchedProdList != null && searchedProdList.size() > 0) {
			if(searchedProdList.size() > 100) {
			Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR,'More than 100 Products found..!!'));
			} else {
				searchedProdListHelper = new List<ProdHelper>();
				for(Product2 prodObj: searchedProdList){
					ProdHelper helper = new ProdHelper();
					helper.prodId = prodObj.Id;
					helper.prodName = prodObj.Name;
					helper.prodCode = prodObj.ProductCode;
					helper.prodIsActive = prodObj.IsActive;
					
					searchedProdListHelper.add(helper);
					system.debug('======================searchedProdListHelper============='+searchedProdListHelper);
				}
			}
			searchFlag = true;
		}else{
			Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR,'Sorry No products found for your search query'));
		}
		searchFlag = true;	
	}

		public void addProducts(){
			List<ProdHelper> addProdHelperListTemp = new List<ProdHelper>();
			for(ProdHelper helperObj : searchedProdListHelper){
				if(helperObj.flag == true && !(selectedHelperIdSet.contains(helperObj.prodId))){
					addProdHelperList.add(helperObj);
					selectedHelperIdSet.add(helperObj.prodId);
					helperObj.flag = false ;
				} else {
					addProdHelperListTemp.add(helperObj);
				}
			}
			searchedProdListHelper = addProdHelperListTemp;
			for(String s : selectedHelperIdSet){
				remainingProductsIdsList.add(s);
			}
			remainingProd();
			addFlag = true;
		}
	

	public void selAllProducts() {
		if(searchedProdListHelper != null && searchedProdListHelper.size() > 0) {
		for(ProdHelper p: searchedProdListHelper) {
			p.flag = prodFlag;
		}
		}
	}
	
	public class ProdHelper{
		public Boolean flag{get;set;} // to set the flags i.e. true or flase and displayd as checkbox on VF page.
		public String prodName {get;set;}
		public String prodId;
		public boolean prodIsActive{get;set;}
		public String prodCode {get;set;}
		public  ProdHelper(){
			flag = false;
		}
	
	}
	
}