public class BPReports 
	extends BPPageBase
{
    private transient List<Job_Seeker__c> tJobSeekers;

    public Boolean ECOnly 
    {
    	get
    	{
    		return CurrentUser.Profile.Name == BPConstants.Profile_BPlusCommunity;
    	}
    }

	public List<Job_Seeker__c> JobSeekers 
	{
		get
		{
			if(tJobSeekers == null)
			{
				tJobSeekers = [SELECT Id, 
	  									Name, 
	  									Account__c, 
	  									Address_Location__c, 
	  									Email__c, 
	  									JSK_ID__c,  
	  									Marketing_Ended__c, 
	  									Marketing_Outcome__c, 
	  									Marketing_Started__c, Mobile__c, 
	  									Professional_and_Specialist_Role__c, 
	  									Qualifications__c, 
	  									Site_and_JSK_ID__c, 
	  									State__c, 
	  									Suburb__c, 
	  									X1_Marketable_Attribute__c, 
	  									X2_Marketable_Attribute__c,
	  									X3_Marketable_Attribute__c, 
	  									Account_Name__c,
	  									Assigned_To__c, 
	  									Assigned_To__r.Name,
	  									(SELECT Id, 
	  											Name,   											   										
	  											Category__c, 
	  											Contact_Email__c, 
	  											Contact_Number__c, 
	  											Contact_Person__c, 
	  											Contact_Position__c, 
	  											Contacted_On__c, 
	  											Hours__c, 
	  											Interview_Date__c, 
	  											Interview_Time__c, 
	  											Job_Details__c, 
	  											Job_Title__c, 
	  											Meeting_Time__c, 
	  											Result__c, 
	  											Sensis_ID__c, 
	  											User__c,
						                        Job_Seeker__c,
						                        Job_Seeker__r.Name,
						                        Business__c, 
						                        Business__r.Name,
						                        User__r.Name
										FROM 	Employer_Contacts__r
										ORDER BY Contacted_On__c),
										(SELECT Id, 
	          									Name,
	          									Employer_Contact__c, 
	          									Actioned__c, 
	          									Address_Confirmed__c, 
	          									Assigned_To__c, 
	          									Contact_Number__c, 
	          									Due_Date__c, 
	          									Email__c, 
	          									Employer_Contact_Person__c, 
	          									Employer_Contact_Position__c,           									
	          									Interview_Date__c, 
	          									Interview_Result__c, 
	          									Interview_Time__c, 
	          									Job_Seeker__c, 
	          									Meeting_Result__c, 
	          									Meeting_Time__c, 
	          									Type__c,
					                            Job_Seeker__r.Name,
					                            Employer__c						
        								FROM 	Follow_Ups__r
        								ORDER BY Due_Date__c)
								FROM 	Job_Seeker__c
								WHERE 	Assigned_To__c = :(ecOnly ? UserInfo.getUserId() : null) OR 
										Name LIKE :(ecOnly ? '~' : '%')
								ORDER BY Name]; 
			}
			return tJobSeekers;
		}
	}
}