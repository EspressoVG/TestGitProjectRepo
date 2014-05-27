global class mp_InboundEmailHandler implements Messaging.Inboundemailhandler {
	global Messaging.Inboundemailresult handleInboundEmail(Messaging.inboundEmail email, Messaging.Inboundenvelope env){
		Contact con = [Select Id, Name, Email From Contact Where Email = :email.fromAddress Limit 1];
			Task newTask = new  Task();
			newTask.WhoId = con.Id;
			newTask.Description =  'ahaagaga';
         	newTask.Priority = 'Normal';
          	newTask.Status = 'Inbound Email';
          	newTask.Subject = 'call';
          	newTask.IsReminderSet = true;
          	insert newTask;
			return null;
	}
	}