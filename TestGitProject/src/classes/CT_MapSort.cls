public class CT_MapSort {
	Map<Integer , String> sortInputMap = new Map<Integer , String>();
	
	public CT_MapSort(){
		sortInputMap.put( 1 , 'Nitish');
		sortInputMap.put( 34 , 'vaibhav');
		sortInputMap.put( 43 , 'Sorabh');
		sortInputMap.put( 2, 'Saurav');
		sortInputMap.put( 41 , 'Ram');
		sortInputMap.put( 55 , 'Shyam');
		System.debug('============sortInputMap=============='+sortInputMap);
		System.debug('============sortInputMap-KeySet=============='+sortInputMap.keySet());
		//Integer intKey = sortInputMap.size();
		List<Integer> intKeyList = new List<Integer>();
		intKeyList.addAll(sortInputMap.keySet());
		System.debug('================intKeyList================'+intKeyList);
		System.debug('================intKeyList.size()================'+intKeyList.size());
		
		Integer temp ;
		for(Integer i = 0 ;i<sortInputMap.size(); i++){
			System.debug('===========KEY LIST 1=================='+intKeyList.get(i));
			System.debug('============sortInputMap-KeySet=============='+sortInputMap.keySet());
		} 
		
	/*	for( Integer i = 0 ; i<intKey.size()-1 ; i++){
			for(Integer j= 1; j<intKey.size(); j++){
				if(intkey[i] > intKey[j]){
					List<Integer> tmpList = new List<Integer>();
					tmpList.remove(i);
					system.debug('=============tmpList=========='+tmpList);
					tmpList.add(intKey[j]);
					system.debug('=============tmpList=========='+tmpList);
				}
			}
		} */
		
		//for(Integer i = 0 ; i< sortInputMap.length() ; i++){
		
		
		//}
	}
	
}