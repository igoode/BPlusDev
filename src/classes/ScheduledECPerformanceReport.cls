global class ScheduledECPerformanceReport implements Schedulable {
	/**
	 * @description Executes the scheduled Apex job. 
	 * @param sc contains the job ID
	 */ 
	global void execute(SchedulableContext sc) 
	{
		for(Account a : [SELECT ID 
					    FROM	Account
					    WHERE	EC_Report_Emails__c != null])
		{
			BPReports.sendECReport(a.ID, Date.today().toStartOfMonth(), Date.today());
		}
	}
}