public without sharing class BPJobSeekerNoSharing 
{
    public static void checkBrokeredLiveUserName(Job_Seeker__c js)
    {
        if(String.isBlank(js.BrokeredLive_Username__c))
        {
            throw new BPException('Username is required.');
        }
        if(js.BrokeredLive_Username__c.length() < 6)
        {
            throw new BPException('Username must be at least 6 characters.');
        }
    	for(Job_Seeker__c jSeeker : [SELECT ID
					    			FROM 	Job_Seeker__c
					    			WHERE 	BrokeredLive_Username__c = :js.BrokeredLive_Username__c AND 
					    					BrokeredLive_Username__c != null AND 
					    					ID != :js.Id])
    	{
    		throw new BPException('This username is already taken.');
    	}
    }
}