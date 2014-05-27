public class CT_regMail {
	public final Registeration__c regObj;
	public CT_regMail(ApexPages.StandardController controller)
	{
	//	String theId = ApexPages.currentPage().getParameters().get('id');
		this.regObj = (Registeration__c)controller.getRecord();
	}
	public void SendEmail()
	{
		Messaging.reserveSingleEmailCapacity(2);
		Messaging.SingleEmailmessage mail = new Messaging.SingleEmailmessage();
		mail.setTargetObjectID(regObj.Id);
		mail.SetTemplateID('00X90000000y7Do');
		Messaging.SendEmail(new Messaging.SingleEmailMessage[] {mail});
	}

}