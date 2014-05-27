public class PieChartController {
	public List<PieWedgeData> getpieData(){
		
		//--Method to return DataList To make Pie Chart-----
		List<PieWedgeData> dataList = new List<PieWedgeData>();
		dataList.add(new PieWedgeData('Jan', 30));
		dataList.add(new PieWedgeData('Feb', 10));
		dataList.add(new PieWedgeData('Mar', 35));
		dataList.add(new PieWedgeData('Apr', 40));
		dataList.add(new PieWedgeData('May', 80));
		dataList.add(new PieWedgeData('June', 90));
		return dataList;
	}
	
	//-----Wrapper Class-----
	public class PieWedgeData{
		public String name{get;set;}
		public Integer data {get;set;}
		
		//-------Constructor----
		public PieWedgeData(String name, Integer data){
			this.name = name;
			this.data = data;
		}
	}
}