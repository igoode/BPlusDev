public with sharing class BPCaseLoadController 
    extends BPPageBase
{
  	public BPCaseLoadController()
  	{}

    private transient List<User> tUsers;
    private transient List<Follow_Up__c> tMyActiveVacancies;
    private transient List<Follow_Up__c> tMyInactiveVacancies;
    private transient List<Follow_Up__c> tOpenActiveVacancies;
    private transient List<Follow_Up__c> tOpenInactiveVacancies;
  
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
                FUFilter.add(new SelectOption('2', 'Followups Actioned'));
                FUFilter.add(new SelectOption('3', 'All Followups'));
            }
            return FUFilter;
        }
        private set;
    }

    public List<SelectOption> EmployerFilter
    {
        get
        {
            if(EmployerFilter == null)
            {
                EmployerFilter = new List<SelectOption>();
                EmployerFilter.add(new SelectOption('Last_Contacted_On__c', 'Last Contacted'));
                EmployerFilter.add(new SelectOption('Name', 'Name'));
            }
            return EmployerFilter;
        }
        private set;
    }

    public List<Follow_Up__c> MyActiveVacancies
    {
        get
        {
          if(tMyActiveVacancies == null)
          {        
              tMyActiveVacancies = getVacancies(true, true);
          }
          return tMyActiveVacancies;
        }
    }

    public List<Follow_Up__c> MyInActiveVacancies
    {
        get
        {
          if(tMyInactiveVacancies == null)
          {        
              tMyInactiveVacancies = getVacancies(true, false);
          }
          return tMyInactiveVacancies;
        }
    }

    public List<Follow_Up__c> OpenActiveVacancies
    {
        get
        {
          if(tOpenActiveVacancies == null)
          {        
              tOpenActiveVacancies = getVacancies(false, true);
          }
          return tOpenActiveVacancies;
        }
    }

    public List<Follow_Up__c> OpenInactiveVacancies
    {
        get
        {
          if(tOpenInactiveVacancies == null)
          {        
              tOpenInactiveVacancies = getVacancies(false, false);
          }
          return tOpenInactiveVacancies;
        }
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
                            Assigned_To__r.Name, 
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
        							//WHERE 	Assigned_To__c IN :Users
        							ORDER BY Name
                      LIMIT 10000];
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
                                  LIMIT 10000];
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
                                Due_Time__c,
              									Email__c,
                                No_Further_Action_Required__c,
              									Employer_Contact_Person__c, 
              									Employer_Contact_Position__c,           									
              									Interview_Date__c, 
              									Result__c, 
              									Interview_Time__c, 
              									Job_Seeker__c,  
              									Type__c,
                                Job_Seeker__r.Name,
                                Employer__c,
                                Employer_Contact__r.Business__r.Name,
                                Job_Seeker__r.Assigned_To__r.Name						
          							FROM 	  Follow_Up__c
          							WHERE 	Job_Seeker__c != null AND
                                Job_Seeker__r.Assigned_To__c IN :Users AND 
                                (
                                      (
                                          Actioned__c = null AND
                                          No_Further_Action_Required__c = false AND
                                          Name LIKE :((SelectedFilter == '1' || String.isBlank(SelectedFilter)) ? '%': '~')
                                      ) OR
                                      (
                                          (Actioned__c != null OR
                                          No_Further_Action_Required__c = true) AND
                                          Name LIKE :(SelectedFilter == '2' ? '%': '~')
                                      ) OR 
                                      Name LIKE :(SelectedFilter == '3' ? '%': '~')
                                )
          							ORDER BY Due_Date__c
                        LIMIT 10000];
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
            if(SelectedFilter == 'Name')
            {
                Employers = [SELECT Id, 
                                  Name, 
                                  Account__c, 
                                  Do_Not_Disturb_Expiry__c, 
                                  Last_Contacted__c,
                                  Last_Contacted_By__c, 
                                  Last_Contacted_By__r.Name,
                                  Last_Result__c 
                          FROM    Business__c
                          ORDER BY Name NULLS LAST 
                          LIMIT 10000];
            }  
            else
            {
              Employers = [SELECT Id, 
                                  Name, 
                                  Account__c, 
                                  Do_Not_Disturb_Expiry__c, 
                                  Last_Contacted__c,
                                  Last_Contacted_By__c, 
                                  Last_Contacted_By__r.Name,
                                  Last_Result__c 
                          FROM    Business__c
                          ORDER BY Last_Contacted_By__c DESC NULLS LAST 
                          LIMIT 10000];
            }
        }
        return Employers;
      }
      private set;
    }


    public void rerenderFollowups()
    {
        FollowUps = null;
        Employers = null;
    }

    public void ceaseMarketing()
    {
        try
        {   
            String jskID = getParameter('jskId');
            Job_Seeker__c jSeeker = new Job_Seeker__c(ID = jskID);
            jSeeker.Marketing_Ended__c = Date.today();
            update jSeeker;
            JobSeekers = null;
        }
        catch(Exception ex)
        {
            addMessage(ex);
        }
    }

    private List<Follow_Up__c> getVacancies(Boolean myVacancies, Boolean activeVacancies)
    {
        Date vacancyClosedDate = activeVacancies ? Date.newInstance(3000, 1, 1) : Date.newInstance(1900, 1, 1);
        ID assignedTo = myVacancies ? UserInfo.getUserId() : null;
        //Boolean openVacancy = 
        List<Follow_Up__c> followups = new List<Follow_Up__c>();      
        for(Employer_Contact__c ec : [SELECT Id,
                                              (SELECT ID,
                                                      Name,
                                                      Employer_Contact__c, 
                                                      Actioned__c, 
                                                      Address_Confirmed__c, 
                                                      Contact_Number__c, 
                                                      CreatedDate,
                                                      CreatedBy.Name,
                                                      Due_Date__c, 
                                                      Due_Time__c,
                                                      Email__c,
                                                      Open_Vacancy__c,
                                                      No_Further_Action_Required__c,
                                                      Employer_Contact_Person__c, 
                                                      Employer_Contact_Position__c,                             
                                                      Interview_Date__c, 
                                                      Result__c, 
                                                      Interview_Time__c,   
                                                      Type__c,
                                                      Vacancy_Closed__c,
                                                      Job_Seeker__c,
                                                      Employer__c,
                                                      Employer_Contact__r.Business__c,
                                                      Employer_Contact__r.Business__r.Name,
                                                      Employer_Contact__r.Business__r.Location__c,
                                                      Employer_Contact__r.Job_Title__c,
                                                      Employer_Contact__r.Comment__c,
                                                      Employer_Contact__r.Open_Vacancy__c,
                                                      Assigned_To__r.Name 
                                                FROM  Follow_Ups__r  
                                                WHERE (
                                                          Vacancy_Closed__c = :(activeVacancies ? null : vacancyClosedDate) OR
                                                          Vacancy_Closed__c > :vacancyClosedDate
                                                      ) AND 
                                                      (
                                                          Assigned_To__c = :assignedTo OR
                                                          Assigned_To__r.Name LIKE :(myVacancies ? '`' : '%')
                                                      ) AND
                                                      (
                                                        Open_Vacancy__c = :!myVacancies 
                                                      )  
                                                // the first followup is th eone that will be assigned to an EC
                                                ORDER BY CreatedDate DESC 
                                                LIMIT 1)   
                                      FROM    Employer_Contact__c
                                      WHERE   Result__c = :BPConstants.EmployerContact_Result_Vacancy
                                      ORDER BY CreatedDate DESC
                                      LIMIT 1000])
    
        {
          followups.addAll(ec.Follow_Ups__r); 
        }
        return followups;
    }
}