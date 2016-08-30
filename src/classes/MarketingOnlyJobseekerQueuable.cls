public class MarketingOnlyJobseekerQueuable implements Queueable
{ 
	public MarketingOnlyJobseekerQueuable(List<Job_Seeker__c> pNewJobseekers)
	{
		newJobseekers = pNewJobseekers;
	}

	private List<Job_Seeker__c> newJobseekers = new List<Job_Seeker__c>();	

	public void execute(QueueableContext context) 
	{
		insert newJobseekers;
	}

}