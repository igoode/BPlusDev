public with sharing class BPCaseLoadController 
    extends BPPageBase
{
  	public BPCaseLoadController()
  	{}

    transient List<User> tUsers;
  
    private List<User> Users
    {
        get
        {
            if(tUsers == null)
            {
                if(IsManager)
                {
                    tUsers = [SELECT  ID 
                            FROM  User 
                            WHERE   AccountID = :CurrentUser.AccountID];
                }
                else
                {
                    tUsers = new List<User>{CurrentUser};
                }
            }
            return tUsers;
        }
    }

    public String SelectedFilter
    {
        get;
        set;
    }

    public List<SelectOption> FUFilter
    {
        get
        {
            if(FUFilter == null)
            {
                FUFilter = new List<SelectOption>();
                FUFilter.add(new SelectOption('1', 'Followups To Do'));
                FUFilter.add(new SelectOption('2', 'Followups Done'));
                FUFilter.add(new SelectOption('3', 'All Followups'));
            }
            return FUFilter;
        }
        private set;
    }

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
        							WHERE 	Assigned_To__c IN :Users
        							ORDER BY Marketing_Started__c DESC NULLS FIRST
                      LIMIT 1000];
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
                  											Result__c, 
                  											Sensis_ID__c, 
                  											User__c,
                                        Job_Seeker__c,
                                        Job_Seeker__r.Name,
                                        Business__c, 
                                        Business__r.Name
                									FROM 	Employer_Contact__c
                									WHERE 	Job_Seeker__r.Assigned_To__c IN :Users
                									ORDER BY Contacted_On__c DESC NULLS FIRST
                                  LIMIT 1000];
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
              									Type__c,
                                Job_Seeker__r.Name,
                                Employer__c,
                                Employer_Contact__r.Business__r.Name						
          							FROM 	  Follow_Up__c
          							WHERE 	Job_Seeker__r.Assigned_To__c IN :Users AND 
                                (
                                      (Actioned__c = null AND
                                      Name LIKE :((SelectedFilter == '1' || String.isBlank(SelectedFilter)) ? '%': '~')) OR
                                      (Actioned__c != null AND
                                      Name LIKE :(SelectedFilter == '2' ? '%': '~')) OR 
                                      Name LIKE :(SelectedFilter == '3' ? '%': '~')
                                )
          							ORDER BY Due_Date__c
                        LIMIT 1000];
  			}
  			return FollowUps;
  		}
      private set;
  	}

    public List<Business__c> Employers
    {
      get
      {
        if(Employers == null)
        {        
            Employers = [SELECT Id, 
                                Name, 
                                Account__c, 
                                Do_Not_Disturb_Expiry__c, 
                                Last_Contacted__c,
                                Last_Contacted_By__c, 
                                Last_Result__c 
                        FROM    Business__c
                        ORDER BY Last_Contacted_By__c DESC NULLS LAST 
                        LIMIT 1000];
        }
        return Employers;
      }
      private set;
    }


    public void rerenderFollowups()
    {
        FollowUps = null;
    }
}