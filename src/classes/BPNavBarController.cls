public with sharing class BPNavBarController
	extends BPPageBase
{
	public Job_Seeker__c MarketingOnlyJobSeeker 
	{
		get
		{
			if(MarketingOnlyJobSeeker == null)
			{
				MarketingOnlyJobSeeker = new Job_Seeker__c();
				for(Job_Seeker__c js : [SELECT	ID
										FROM	Job_Seeker__c 
										WHERE	Assigned_To__c = :UserInfo.getUserId() AND 
												Assigned_To__r.Marketing_Only__c = true]) 
				{
					MarketingOnlyJobSeeker = js;
				}
			}
			return MarketingOnlyJobSeeker;
		}
		set;
	}
}