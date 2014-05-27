global class CT_ScheduleBatchDeleteInactiveAccount implements schedulable {
	global void execute(SchedulableContext SC) {
	 	CT_BatchDeleteInactiveAccounts b = new CT_BatchDeleteInactiveAccounts();
	 	database.executebatch(b);
	}
}