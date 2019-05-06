public class ScheduledECActivityReport  implements Schedulable
{
    public void execute(SchedulableContext sc)
    {
        for(Account a : [SELECT ID
                        FROM    Account
                        WHERE   EC_Activity_Report_Emails__c != null AND
                                EC_Activity_Report_Midweek__c = false AND
                                Activity_Report_Active__c = true])
        {
            BPReports.sendECActivityReport(a.ID, Date.today().toStartOfWeek().addDays(1), Date.today(), true);
        }
    }
}