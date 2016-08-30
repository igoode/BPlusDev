trigger trgUser on User (before insert, before update, before delete, after insert, after update, after delete)  
{ 
	if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate))
	{
		Set<ID> markOnlyUserWithJobseekers = new Set<ID>();
		for(Job_Seeker__c js : [SELECT	ID,
										Assigned_to__c
								FROM	Job_Seeker__c 
								WHERE	Marketing_Only__c = true AND 
										Assigned_To__c IN :Trigger.new AND 
										Assigned_To__r.Marketing_Only__c = true]) 
		{
			markOnlyUserWithJobseekers.add(js.Assigned_to__c);
		}
		List<Job_Seeker__c> newJobseekers = new List<Job_Seeker__c>();		
		for(User u : Trigger.new)
		{
			if(u.Marketing_Only__c && !markOnlyUserWithJobseekers.contains(u.ID))
			{
				Job_Seeker__c js = new Job_Seeker__c();
				js.Account__c = u.AccountID;
				js.Assigned_To__c = u.ID;
				js.Name = u.Full_Name__c;
				js.Marketing_Only__c = true;
				newJobseekers.add(js);
			}
		}
		if(!newJobseekers.isEmpty())
		{
			System.enqueueJob(new MarketingOnlyJobseekerQueuable(newJobseekers));
		}
	}
}