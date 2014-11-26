public class BPCaseLoadController 
{
  	public BPCaseLoadController()
  	{}

  	public List<Job_Seeker__c> JobSeekers 
  	{
  		get
  		{
  			if(JobSeekers == null)
  			{
  				JobSeekers = [SELECT Id, 
  									Name, 
  									Account__c, 
  									Address_Location__c, 
  									Assigned_To__c, 
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
  									Account_Name__c 
							FROM 	Job_Seeker__c
							WHERE 	Assigned_To__c = :UserInfo.getUserId() 
							ORDER BY Marketing_Started__c DESC NULLS FIRST];
  			}
  			return JobSeekers;
  		}
  		private set;
  	}

  	public List<Employer_Contact__c> EmployerContacts 
  	{
  		get
  		{
  			if(EmployerContacts == null)
  			{
  				EmployerContacts = [SELECT Id, 
  											Name, 
  											Job_Seeker__c, 
  											Business__c, 
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
  											User__c 
									FROM 	Employer_Contact__c
									WHERE 	Job_Seeker__r.Assigned_To__c = :UserInfo.getUserId() 
									ORDER BY Contacted_On__c DESC NULLS FIRST];
  			}
  			return EmployerContacts;
  		}
  		private set;
  	}

  	public List<Follow_Up__c> FollowUps 
  	{
  		get
  		{
  			if(FollowUps == null)
  			{
  				FollowUps = [SELECT Id, 
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
        							FROM 	Follow_Up__c
        							WHERE 	Job_Seeker__r.Assigned_To__c = :UserInfo.getUserId() 
        							ORDER BY Due_Date__c DESC NULLS FIRST];
  			}
  			return FollowUps;
  		}
  		private set;
  	}
}