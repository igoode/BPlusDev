public class ScheduledECActivityReport  implements Schedulable
{
    public void execute(SchedulableContext sc)
    {
        for(Account a : [SELECT ID
                        FROM    Account
                        WHERE   EC_Activity_Report_Emails__c != null])
        {
            BPReports.sendECActivityReport(a.ID, Date.today(), Date.today());
        }
    }
}