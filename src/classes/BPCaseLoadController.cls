public with sharing class BPCaseLoadController 
    extends BPPageBase
{
  	public BPCaseLoadController()
  	{}

    public BPCaseLoadController(object o)
    {}

    private transient List<User> tUsers;
    private transient List<Follow_Up__c> tMyActiveVacancies;
    private transient List<Follow_Up__c> tMyInactiveVacancies;
    private transient List<Follow_Up__c> tOpenActiveVacancies;
    private transient List<Follow_Up__c> tOpenInactiveVacancies;
    private transient List<Business__c> tEmployers;
    private transient List<Job_Seeker__c> tJobSeekers;
    private transient List<Employer_Contact__c> tEmployerContacts ;
    private transient List<Follow_Up__c> tFollowUps;
    private transient List<Employer_Contact__c> tSignups;
    private transient List<Employer_Contact__c> tReferrals;
  
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

    public String SelectedConsultant
    {
        get;
        set;
    }

	public String EmployerSearch
	{
		get;
		set;
	}

	public String ResultSearch
	{
		get;
		set;
	}

	public Date FromDateSearch
	{
		get;
		set;
	}

	public Date ToDateSearch
	{
		get;
		set;
	}

    public List<SelectOption> ReferralConsultants
    {
        get
        {
            List<SelectOption> users = Consultants;
            users[0] = new SelectOption('', '--All--');
            return users;
        }
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
				EmployerFilter.add(new SelectOption('Name', 'Name'));
                EmployerFilter.add(new SelectOption('Last_Contacted_On__c', 'Last Contacted'));
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
				tMyActiveVacancies = new List<Follow_Up__c>();
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
													WHERE RecordType.Name = :BPConstants.FollowUp_RecordType_Followup AND
                                                            Vacancy_Closed__c = null AND
														  CreatedByID = :UserInfo.getUserId() AND
														  Open_Vacancy__c = false
													// the first followup is th eone that will be assigned to an EC
													ORDER BY CreatedDate DESC 
													LIMIT 1)   
										  FROM    Employer_Contact__c
										  WHERE   Result__c = :BPConstants.EmployerContact_Result_Vacancy
										  ORDER BY CreatedDate DESC
										  LIMIT 1000])
    
				{
					tMyActiveVacancies.addAll(ec.Follow_Ups__r); 
				}
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
			  tMyInactiveVacancies = new List<Follow_Up__c>();
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
													WHERE RecordType.Name = :BPConstants.FollowUp_RecordType_Followup AND
                                                            Vacancy_Closed__c != null AND
														  CreatedByID = :UserInfo.getUserId() AND
														  Open_Vacancy__c = false
													// the first followup is th eone that will be assigned to an EC
													ORDER BY CreatedDate DESC 
													LIMIT 1)   
										  FROM    Employer_Contact__c
										  WHERE   Result__c = :BPConstants.EmployerContact_Result_Vacancy
										  ORDER BY CreatedDate DESC
										  LIMIT 1000])
    
				{
					tMyInactiveVacancies.addAll(ec.Follow_Ups__r); 
				}
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
				tOpenActiveVacancies = new List<Follow_Up__c>();  
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
													WHERE RecordType.Name = :BPConstants.FollowUp_RecordType_Followup AND
                                                         Vacancy_Closed__c = null AND
														  Open_Vacancy__c = true
													// the first followup is th eone that will be assigned to an EC
													ORDER BY CreatedDate DESC 
													LIMIT 1)   
										  FROM    Employer_Contact__c
										  WHERE   Result__c = :BPConstants.EmployerContact_Result_Vacancy
										  ORDER BY CreatedDate DESC
										  LIMIT 1000])
    
				{
					tOpenActiveVacancies.addAll(ec.Follow_Ups__r); 
				}      
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
			  tOpenInactiveVacancies = new List<Follow_Up__c>();
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
													WHERE RecordTypeID = :BPConstants.FollowUp_RecordType_Followup_ID AND
															Vacancy_Closed__c != null AND
														  Open_Vacancy__c = true
													// the first followup is th eone that will be assigned to an EC
													ORDER BY CreatedDate DESC 
													LIMIT 1)   
										  FROM    Employer_Contact__c
										  WHERE   Result__c = :BPConstants.EmployerContact_Result_Vacancy
										  ORDER BY CreatedDate DESC
										  LIMIT 1000])
    
				{
					tOpenInactiveVacancies.addAll(ec.Follow_Ups__r); 
				}      
          }
          return tOpenInactiveVacancies;
        }
    }

	public List<Employer_Contact__c> Signups
	{
		get
		{
			if(tSignups == null)
			{
                tSignups = [SELECT Id,
                                    Business__c,
                                    Business__r.Name,
                                    Contacted_On__c,
                                    User__c,
                                    User__r.Name,
                                    CreatedByID,
                                    CreatedBy.Name,
									Referral_From__c,
									Referral_From__r.User__r.Name,
                                    Signups__c,
                                    Signups_Complete_Count__c,
                                    Signups_Incomplete__c,
                                    Comment__c
                            FROM    Employer_Contact__c
                            WHERE   Result__c LIKE :('%' + BPConstants.EmployerContact_Result_Signup) AND
                                    User__c = :CurrentUser.ID AND
                                    Referral_To__c = null
                            ORDER BY CreatedDate DESC
                            LIMIT 1000];
			}
			return tSignups;
		}
	}

    public List<Employer_Contact__c> Referrals
    {
        get
        {
            if(tReferrals == null)
            {
                tReferrals = [SELECT Id,
                                    Business__c,
                                    Business__r.Name,
                                    Contacted_On__c,
                                    CreatedByID,
                                    CreatedBy.Name,
                                    Signups__c,
                                    Signups_Complete_Count__c,
                                    Signups_Incomplete__c,
                                    User__c,
                                    User__r.Name,
                                    Comment__c,
                                    Referral_To__r.User__r.Name
                            FROM    Employer_Contact__c
                            WHERE   Result__c = :BPConstants.EmployerContact_Result_Referral AND
                                    User__c = :CurrentUser.ID/* AND
                                    (User__c = :SelectedConsultant OR
                                    Name LIKE :(String.isBlank(SelectedConsultant) ? '%' : '~'))*/
                ORDER BY CreatedDate DESC
                LIMIT 1000];
            }
            return tReferrals;
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
          									Assigned_To__c,
                                            Assigned_To__r.Name,
          									Email__c, 
          									Marketing_Ended__c, 
          									Marketing_Outcome__c, 
          									Marketing_Started__c,
          									Professional_and_Specialist_Role__c, 
          									Qualifications__c, 
          									State__c, 
          									Suburb__c, 
          									X1_Marketable_Attribute__c, 
          									X2_Marketable_Attribute__c,
          									X3_Marketable_Attribute__c, 
          									Account_Name__c,
                                            Recent_Marketed_Order_By__c
        							FROM 	Job_Seeker__c
        							//WHERE 	Assigned_To__c IN :Users
        							ORDER BY Name
                      LIMIT 10000];
  			}
  			return tJobSeekers;
  		}
  	}

  	public List<Employer_Contact__c> EmployerContacts 
  	{
  		get
  		{
    			if(tEmployerContacts == null)
    			{
      				tEmployerContacts = [SELECT Id, 
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
    			return tEmployerContacts;
  		}
  	}

  	public List<Follow_Up__c> FollowUps 
  	{
  		get
  		{
  			if(FollowUps == null)
  			{        
    				tFollowUps = [SELECT Id, 
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
												Employer_Contact__r.Contact_Number__c,
                                                Job_Seeker__r.Assigned_To__r.Name
          							FROM 	    Follow_Up__c
          							WHERE 	    RecordType.Name = :BPConstants.FollowUp_RecordType_Followup AND
                                                Job_Seeker__c != null AND
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
  			return tFollowUps;
  		}
  	}

    public List<Business__c> Employers
    {
      get
      {
        if(tEmployers == null) 
        {      
            if(String.isBlank(SelectedFilter) || SelectedFilter == 'Name')
            {
                tEmployers = [SELECT Id, 
                                  Name, 
                                  Account__c, 
                                  Do_Not_Disturb_Expiry__c, 
                                  Last_Contacted__c,
                                  Last_Contacted_By__c, 
                                  Last_Contacted_By__r.Name,
                                  Last_Result__c 
                          FROM    Business__c
                          ORDER BY Name NULLS LAST 
                          LIMIT 1000];
            }  
            else
            {
              tEmployers = [SELECT Id, 
                                  Name, 
                                  Account__c, 
                                  Do_Not_Disturb_Expiry__c, 
                                  Last_Contacted__c,
                                  Last_Contacted_By__c, 
                                  Last_Contacted_By__r.Name,
                                  Last_Result__c 
                          FROM    Business__c
                          ORDER BY Last_Contacted__c DESC NULLS LAST
                          LIMIT 1000];
            }
        }
        return tEmployers;
      }
    }

    public void rerenderEmployers()
    {
        tEmployers = null;
        SelectedFilter = getParameter('sort');
    }

    public void rerenderFollowups()
    {
    }

    public void rerenderReferrals()
    {
        tReferrals = null;
    }

    public void ceaseMarketing()
    {
        try
        {   
            String jskID = getParameter('jskId');
            Job_Seeker__c jSeeker = new Job_Seeker__c(ID = jskID);
            jSeeker.Marketing_Ended__c = Date.today();
            update jSeeker;
        }
        catch(Exception ex)
        {
            addMessage(ex);
        }
    }

	public void filterContacts()
	{

	}
}