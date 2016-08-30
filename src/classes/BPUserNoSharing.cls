public without sharing class BPUserNoSharing 
{
    public static User getAdminUser()
    {
    	return [SELECT ID 
				FROM 	User 
				WHERE 	Profile.Name = :BPConstants.Profile_SystemAdministrator AND 
						IsActive = true 
				LIMIT 1];
    }
}