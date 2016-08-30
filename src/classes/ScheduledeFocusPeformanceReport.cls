global class ScheduledeFocusPeformanceReport implements Schedulable {
	/**
	 * @description Executes the scheduled Apex job. 
	 * @param sc contains the job ID
	 */ 
	global void execute(SchedulableContext sc) 
	{
		//for(Account a : [SELECT ID 
					//FROM	Account 
					//WHERE	Name = 'eFocus - WCN'])
		//{
			//BPReports.sendECReport(a.ID, Date.today().toStartOfMonth(), Date.today());
		//}
	}
}