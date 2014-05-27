public class mp_Exercise11 {
	private final Account acc;
	public mp_Exercise11(){
		acc = [Select id, Name, Site from Account where Id=: ApexPages.currentPage().getParameters().get('id')];
	}
	public Account getAcc(){
		return acc;
	}
	public Pagereference save(){
		update acc;
		return new Pagereference('http://www.google.com');
	}
}