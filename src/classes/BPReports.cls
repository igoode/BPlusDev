public with sharing class BPReports 
	extends BPPageBase
{
    public BPReports()
    {
    }

    private transient List<Job_Seeker__c> tJobSeekers;
    private transient List<User> tECs;
	private transient List<Employer_Contact__c> tECVacancies;
    private Date fDate;
    private Date tDate;

    public static Set<String> CustomResults
    {
        get
        {
            if (CustomResults == null)
            {
                CustomResults = new Set<String>();
                User currUser = (new BPPageBase()).CurrentUser;
                if (currUser.Contact.Account.Employer_Contact_Results__c != null) {
                    CustomResults.addAll(currUser.Contact.Account.Employer_Contact_Results__c.split(';'));
                }
                if (currUser.Contact.Account.Followup_Results__c != null) {
                    CustomResults.addAll(currUser.Contact.Account.Followup_Results__c.split(';'));
                }
            }
            return CustomResults;
        }
        private set;
    }
    public Boolean ECOnly 
    {
    	get
    	{
    		return CurrentUser.Profile.Name == BPConstants.Profile_BPlusCommunity;
    	}
    }

	public Account CurrentAccount
	{
    	get
		{
			if (CurrentAccount == null)
			{
				ID accountID = getParameter('acc');
				if(String.isBlank(accountID))
				{
					CurrentAccount = new Account(ID = CurrentUser.Contact.AccountId, Name = CurrentUser.Contact.Account.Name);
				}
				else 
				{
					for(Account  a: [SELECT Id,
											Name 
									FROM	Account 
									WHERE	ID = :accountID])
					{
						CurrentAccount = a;
					}
				}
			}
			return CurrentAccount;
		}
    	set;
    }

    public String FromDate
    {
    	get;
    	set;
    }

    public String ToDate
    {
    	get;
    	set;
    }

	public String Days
	{
		get;
		private set;
	}

    public String ReportPeriod
    {
        get;
        private set;
    }

    public String SelectedPeriod
    {
    	get;
    	set;
    }

 	public String SelectedECID
    {
    	get;
    	set;
    }

    public ECPerfomanceTotal Total
    {
        get
        {
            if(Total == null)
            {
                Total = new ECPerfomanceTotal(ECPerfomance);
            }
            return Total;
        }
        private set;
    }

    public List<SelectOption> SiteECs
	{
		get
		{
			if(SiteECs == null)
			{
				SiteECs = getSelectListFromObjectList([SELECT 	ID, 
																Name 
														FROM 	User
														WHERE 	AccountID != null AND 
																IsActive = true]);
			}
			return SiteECs;
		}
		private set;
	} 

    public List<SelectOption> Periods 
    {
    	get
    	{
	    	if(Periods == null)
	    	{
	    		Periods = new List<SelectOption>();
	    		Periods.add(new SelectOption('', '--All--'));
	    		Periods.add(new SelectOption('1', 'Last Week'));
	    		Periods.add(new SelectOption('2', 'Last Month'));
	    		Periods.add(new SelectOption('3', 'Last 3 Months'));
	    	}
	    	return Periods;
	    }
	    private set;
    }
	
    @TestVisible
    public Job_Seeker__c JobSeeker
	{
		get
		{							
			if(JobSeeker == null)
			{
				getDates();
				String jobSeekerID = getParameter('jskId');
				String liveSessionId = getParameter('sessId');
				if(String.isNotBlank(liveSessionId))
				{
					for(Live_Session__c ls : [SELECT Job_Seeker__c 
											FROM 	Live_Session__c 
											WHERE 	ID = :liveSessionId AND 
													Job_Seeker__c = :getParameter('chkId')])
					{
						JobSeeker = [SELECT Id, 
  									Name, 
  									Account__c, 
  									Address_Location__c, 
  									Email__c,  
  									Marketing_Ended__c, 
  									Marketing_Outcome__c, 
  									Marketing_Started__c, 
  									Marketing_Start_Date__c,
  									Days_Marketed__c,
  									Professional_and_Specialist_Role__c, 
  									Qualifications__c, 
  									State__c, 
  									Suburb__c, 
  									X1_Marketable_Attribute__c, 
  									X2_Marketable_Attribute__c,
  									X3_Marketable_Attribute__c, 
  									Account_Name__c,
  									BrokeredLive__c,
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
  											Comment__c,
  											Hours__c, 
  											Interview_Date__c, 
  											Interview_Time__c, 
  											Job_Details__c, 
  											Job_Title__c, 
  											Result__c, 
  											Sensis_ID__c, 
											Address__c,
					                        Job_Seeker__c,
					                        Job_Seeker__r.Name,
					                        Business__c, 
					                        Business__r.Name,
					                        Business__r.Location__c
									FROM 	Employer_Contacts__r
									WHERE 	Live_Session__c = :liveSessionId
									ORDER BY Contacted_On__c)
							FROM 	Job_Seeker__c
							WHERE 	ID = :ls.Job_Seeker__c];
					}
				}
				else
				{
					JobSeeker = [SELECT Id, 
	  									Name, 
	  									Account__c, 
	  									Address_Location__c, 
	  									Email__c, 
	  									Marketing_Ended__c, 
	  									Marketing_Outcome__c, 
	  									Marketing_Started__c, 
	  									Marketing_Start_Date__c,
	  									Days_Marketed__c,
	  									Professional_and_Specialist_Role__c, 
	  									Qualifications__c, 
	  									State__c, 
	  									Suburb__c, 
	  									X1_Marketable_Attribute__c, 
	  									X2_Marketable_Attribute__c,
	  									X3_Marketable_Attribute__c, 
	  									Account_Name__c,
	  									BrokeredLive__c,
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
	  											Comment__c,
                                                Address__c,
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
						                        Business__r.Name,
						                        User__r.Name
										FROM 	Employer_Contacts__r
										WHERE 	Live_Session__c = null AND
												DAY_ONLY(Contacted_On__c) >= :fDate AND 
												DAY_ONLY(Contacted_On__c) <= :tDate
										ORDER BY Contacted_On__c),
										(SELECT Id, 
	          									Name,          									 
	          									Actioned__c, 
	          									Address_Confirmed__c, 
	          									Action_Taken__c,
	          									Assigned_To__c, 
	          									Assigned_To__r.Name,
	          									Contact_Number__c, 
	          									Due_Date__c, 
	          									Email__c, 
	          									Employer_Contact_Person__c, 
	          									Employer_Contact_Position__c,           									
	          									Interview_Date__c, 
	          									Result__c,
	          									Interview_Time__c,
	          									Job_Seeker__c, 
	          									Type__c,
	          									Comment__c,
					                            Job_Seeker__r.Name,
					                            Employer_Contact__c,
					                            Employer_Contact__r.Result__c,
					                            Employer__c
	    								FROM 	Follow_Ups__r
	    								WHERE 	Due_Date__c >= :fDate AND 
												Due_Date__c <= :tDate
	    								ORDER BY Due_Date__c),
	    								(SELECT ID, 
	    										Sent__c,
	    										Delivered__c,
	    										Type__c,
	    										Message__c
	    								FROM 	SMS_Notifications__r
	    								WHERE 	Sent__c >= :fDate AND 
												Sent__c <= :tDate
	    								ORDER BY Sent__c),
	    								(SELECT ID, 
	    										Employer__r.Name,
	    										CreatedDate
	    								FROM 	Wage_Subsidies__r
	    								WHERE 	CreatedDate >= :fDate AND 
												CreatedDate <= :tDate
	    								ORDER BY CreatedDate)
								FROM 	Job_Seeker__c
								WHERE 	ID = :jobSeekerID];
				}
			}
			return JobSeeker;
		}
		private set;
	}

	public Job_Seeker__c BrokeredLiveJobSeeker
	{
		get
		{
			if(BrokeredLiveJobSeeker == null)
			{
				String jobSeekerID = getParameter('jskId');
				BrokeredLiveJobSeeker =  
							[SELECT Id, 
  									Name, 
  									Account__c, 
  									Address_Location__c, 
  									Email__c,  
  									Marketing_Ended__c, 
  									Marketing_Outcome__c, 
  									Marketing_Started__c, 
  									Marketing_Start_Date__c,
  									Days_Marketed__c,
  									Professional_and_Specialist_Role__c, 
  									Qualifications__c, 
  									State__c, 
  									Suburb__c, 
  									X1_Marketable_Attribute__c, 
  									X2_Marketable_Attribute__c,
  									X3_Marketable_Attribute__c, 
  									Account_Name__c,
  									BrokeredLive__c,
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
  											Result__c, 
  											Sensis_ID__c, 
  											Comment__c,
					                        Job_Seeker__c,
					                        Job_Seeker__r.Name,
					                        Live_Session__r.CreatedDate,
					                        Business__c, 
					                        Business__r.Name,
					                        Business__r.Location__c
									FROM 	Employer_Contacts__r
									WHERE 	Live_Session__c != null
									ORDER BY Contacted_On__c)
							FROM 	Job_Seeker__c
							WHERE 	ID = :jobSeekerID];
			}
			return BrokeredLiveJobSeeker;
		}
		set;
	}

	public List<Job_Seeker__c> JobSeekers 
	{
		get
		{							
			if(tJobSeekers == null)
			{
				getDates();
				tJobSeekers = [SELECT Id, 
	  									Name, 
	  									Account__c, 
	  									Address_Location__c, 
	  									Email__c, 
	  									Marketing_Ended__c, 
	  									Marketing_Outcome__c, 
	  									Marketing_Started__c, 
	  									Marketing_Start_Date__c,
	  									Days_Marketed__c,
	  									Professional_and_Specialist_Role__c, 
	  									Qualifications__c, 
	  									State__c, 
	  									Suburb__c, 
	  									X1_Marketable_Attribute__c, 
	  									X2_Marketable_Attribute__c,
	  									X3_Marketable_Attribute__c, 
	  									Account_Name__c,
	  									BrokeredLive__c,
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
	  											Result__c, 
	  											Sensis_ID__c,
                                                Address__c,
	  											User__c,
						                        Job_Seeker__c,
						                        Job_Seeker__r.Name,
						                        Business__c, 
						                        Business__r.Name,
						                        User__r.Name
										FROM 	Employer_Contacts__r
										WHERE 	Live_Session__c = null AND 
                                                DAY_ONLY(Contacted_On__c) >= :fDate AND 
												DAY_ONLY(Contacted_On__c) <= :tDate
										ORDER BY Contacted_On__c),
										(SELECT Id, 
	          									Name,
	          									Actioned__c, 
	          									Address_Confirmed__c, 
	          									Assigned_To__c, 
	          									Contact_Number__c, 
	          									Due_Date__c, 
	          									Action_Taken__c,
	          									Email__c, 
	          									Employer_Contact_Person__c, 
	          									Employer_Contact_Position__c,           									
	          									Interview_Date__c, 
	          									Result__c, 
	          									Interview_Time__c, 
	          									Job_Seeker__c, 	          					
	          									Type__c,
					                            Job_Seeker__r.Name,
					                            Employer__c,
					                            Employer_Contact__c,
					                            Employer_Contact__r.Result__c				
        								FROM 	Follow_Ups__r
        								WHERE 	Due_Date__c >= :fDate AND 
												Due_Date__c <= :tDate
        								ORDER BY Due_Date__c)
								FROM 	Job_Seeker__c
								WHERE 	(
											Assigned_To__c = :(ECOnly ? UserInfo.getUserId() : null) OR 
											Name LIKE :(ECOnly ? '~' : '%')
										) AND 
										ID IN (SELECT 	Job_Seeker__c 
												FROM 	Employer_Contact__c 
												WHERE 	DAY_ONLY(Contacted_On__c) >= :fDate AND 
														DAY_ONLY(Contacted_On__c) <= :tDate)
								ORDER BY Assigned_To__r.Name, Name]; 
			}
			return tJobSeekers;
		}
	}

    public Map<String, List<Employer_Contact__c>> EmployerContactsByEC
    {
        get
        {
            if(EmployerContactsByEC == null)
            {
                getDates();
                EmployerContactsByEC = new Map<String, List<Employer_Contact__c>>();
                for(User u : getAllUsers())
                {
                    EmployerContactsByEC.put(u.Name, new List<Employer_Contact__c>());
                }
                String site = getParameter('site');
                if(String.isBlank(site))
                {
                    site = null;
                }
                for(Employer_Contact__c empCon : [SELECT Id,
                                                    Name,
                                                    Category__c,
                                                    Contact_Email__c,
                                                    Contact_Number__c,
                                                    Contact_Person__c,
                                                    Contact_Position__c,
                                                    Contacted_On__c,
                                                    Comment__c,
                                                    Address__c,
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
                                                    Job_Seeker__r.Site__c,
                                                    Business__c,
                                                    Business__r.Name,
                                                    Business__r.ABN__c,
                                                    User__r.Name
                                            FROM 	Employer_Contact__c
                                            WHERE 	Result__c != null AND
                                                    User__c != null AND
                                                    DAY_ONLY(convertTimezone(Contacted_On__c)) >= :fDate AND
                                                    DAY_ONLY(convertTimezone(Contacted_On__c)) <= :tDate AND
                                                    //User__c In :getUserIds(fDate, tDate) AND
                                                    Job_Seeker__r.Account__c = :CurrentAccount.ID AND
                                                    (Job_Seeker__r.Site__c = :site OR
                                                    Name LIKE :(String.isBlank(site) ? '%' : '~'))
                                            ORDER BY User__r.Name,
                                                    Contacted_On__c])
                {
                    EmployerContactsByEC.get(empCon.User__r.Name).add(empCon);
                }
            }
            return EmployerContactsByEC;
        }
        private set;
    }

    public List<User> ECs
	{
		get
		{							
			if(tECs == null)
			{
				getDates();
				
				tECs = [SELECT Id, 
									Name, 
									(SELECT Id, 
											Name,
											Category__c, 
											Contact_Email__c, 
											Contact_Number__c, 
											Contact_Person__c, 
											Contact_Position__c, 
											Contacted_On__c,
											Comment__c,
											Address__c,
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
					                        Business__r.Name,
											Business__r.ABN__c,
											User__r.Name
									FROM 	Employer_Contacts__r
									WHERE 	Result__c != :BPConstants.EmployerContact_Result_Vacancy AND
											Result__c != null AND
											DAY_ONLY(convertTimezone(Contacted_On__c)) >= :fDate AND
											DAY_ONLY(convertTimezone(Contacted_On__c)) <= :tDate
									ORDER BY Contacted_On__c),
									(SELECT Id, 
	      									Name,
                                            CreatedDate,
	      									Actioned__c, 
	      									Address_Confirmed__c, 
	      									Assigned_To__c, 
	      									Action_Taken__c,
											Comment__c,
	      									Contact_Number__c, 
	      									Due_Date__c, 
	      									Email__c, 
	      									Employer_Contact_Person__c, 
	      									Employer_Contact_Position__c,           									
	      									Interview_Date__c, 
	      									Result__c, 
	      									Interview_Time__c, 
	      									Job_Seeker__c, 
	      									Type__c,
	      									No_Further_Action_Required__c,
				                            Job_Seeker__r.Name,
				                            Employer__c,
				                            Employer_Contact__c,
				                            Employer_Contact__r.Result__c					
									FROM 	Follow_Ups__r
									WHERE 	/*(Due_Date__c >= :fDate AND
											Due_Date__c <= :tDate) OR*/
									        (DAY_ONLY(convertTimeZone(Actioned__c)) >= :fDate AND
                                            DAY_ONLY(convertTimeZone(Actioned__c)) <= :tDate) OR
                                            (DAY_ONLY(convertTimeZone(CreatedDate)) >= :fDate AND
                                            DAY_ONLY(convertTimeZone(CreatedDate)) <= :tDate)
									ORDER BY Due_Date__c)
						FROM 	User
						WHERE 	ID IN :getUserIds(fDate, tDate)
						ORDER BY Name]; 
			}
			return tECs;
		}
	}

	public List<Employer_Contact__c> ECVacancies 
	{
		get
		{							
			if(tECVacancies == null)
			{
				getDates();
				tECVacancies = [SELECT Id, 
										Name,
                                        Address__c,
										Category__c, 
										Contact_Email__c, 
										Contact_Number__c, 
										Contact_Person__c, 
										Contact_Position__c, 
										Contacted_On__c,
										Comment__c,
										Hours__c, 
										Interview_Date__c, 
										Interview_Time__c, 
										Job_Details__c, 
										Job_Title__c, 
										Result__c, 
										Sensis_ID__c, 
										Open_Vacancy__c,
										User__c,
										Job_Seeker__c,
										Job_Seeker__r.Name,
										Business__c, 
										Business__r.Name,
                                        Business__r.ABN__c,
										CreatedDate,
										CreatedBy.Name
								FROM 	Employer_Contact__c
								WHERE 	Result__c = :BPConstants.EmployerContact_Result_Vacancy AND
										DAY_ONLY(convertTimeZone(CreatedDate)) >= :fDate AND
										DAY_ONLY(convertTimeZone(CreatedDate)) <= :tDate AND
										CreatedById IN :getUserIds(fDate, tDate)
								ORDER BY CreatedDate]; 
			}
			return tECVacancies;
		}
	}

	public List<ECWrapper> ECPerfomance
	{
		get
		{
			if(ECPerfomance == null)
			{
				getDates();
				Map<ID, ECWrapper> wrappersByUserID = new Map<ID, ECWrapper>();
				for(AggregateResult result : [SELECT User__c,
													User__r.Name userName,
													Result__c,
													COUNT(ID)  callCount
											FROM 	Employer_Contact__c
											WHERE 	User__c != null AND 
													Job_Seeker__r.Account__c = :CurrentAccount.ID AND
													//Result__c != :(Test.isRunningTest() ? null : BPConstants.EmployerContact_Result_Vacancy) AND
                                                    Result__c != null AND
													DAY_ONLY(Contacted_On__c) >= :fDate AND 
													DAY_ONLY(Contacted_On__c) <= :tDate 
											GROUP BY User__c,
													User__r.Name,
													Result__c])
				{
					ID ecID = ID.valueOf((String)result.get('User__c'));
					String ecName = String.valueOf((String)result.get('userName'));
					Decimal callCount = (Decimal)result.get('callCount');
					ECWrapper wrapper;
					if(wrappersByUserID.containsKey(ecID))
					{
						wrapper = wrappersByUserID.get(ecID); 
					}
					else
					{
						wrapper = new ECWrapper(new User(ID = ecID, LastName = ecName));
						wrappersByUserID.put(ecID, wrapper);
					}
					String ecResult = (String)result.get('Result__c');
					wrapper.incrementCalls(callCount.intValue(), ecResult);
				}

				ECPerfomance = wrappersByUserID.values();
				ECPerfomance.sort();
			}
			return ECPerfomance;
		}
		private set;
	}

    public  Set<String> ContactResults
    {
        get
        {
            if(ContactResults == null)
            {
                ContactResults = new Set<String>{'Resume sent',
                        'Interview',
                        'Paid work trial',
                        'Offered employment',
                        'Placed',
                        'Resume drop off',
                        'Vacancy'};
            }
            return ContactResults;
        }
        private set;
    }

    public List<EmployerWrapper> EmployerResults
    {
        get
        {
            if(EmployerResults == null)
            {
                String month = getParameter('month');
                EmployerResults = new List<EmployerWrapper>();
                for(Business__c b : [SELECT ID,
                                            Name,
                                            Phone__c,
                                            (SELECT   ID,
                                                    Result_Display__c
                                            FROM    Employer_Contacts__r
                                            WHERE   Month__c = :month AND
                                                    Result_Display__c IN :ContactResults)
                                    FROM    Business__c
                                    WHERE   Account__c = :CurrentUser.AccountId AND
                                            ID IN (SELECT   Business__c
                                                    FROM    Employer_Contact__c
                                                    WHERE   Month__c = :month AND
                                                            Result_Display__c IN :ContactResults)
                                    ORDER BY Name])
                {
                    EmployerResults.add(new EmployerWrapper(b, ContactResults));
                }
            }
            return EmployerResults;
        }
        private set;
    }

	public List<ECWrapper> JSPerfomance
	{
		get
		{
			if(JSPerfomance == null)
			{
				getDates();
				Map<ID, ECWrapper> wrappersByUserID = new Map<ID, ECWrapper>();
				for(AggregateResult result : [SELECT Job_Seeker__c,
                                                    Job_Seeker__r.Name jsName,
                                                    Result__c,
                                                    COUNT(ID)  callCount
                                            FROM 	Employer_Contact__c
                                            WHERE 	Job_Seeker__c != null AND
                                                    Job_Seeker__r.Account__c = :CurrentAccount.ID AND
                                                    Result__c != null AND
                                                    DAY_ONLY(Contacted_On__c) >= :fDate AND
                                                    DAY_ONLY(Contacted_On__c) <= :tDate
                                            GROUP BY Job_Seeker__c,
                                                    Job_Seeker__r.Name,
                                                    Result__c])
				{
					ID jsID = ID.valueOf((String)result.get('Job_Seeker__c'));
					String jsName = String.valueOf((String)result.get('jsName'));
					Decimal callCount = (Decimal)result.get('callCount');
					ECWrapper wrapper;
					if(wrappersByUserID.containsKey(jsID))
					{
						wrapper = wrappersByUserID.get(jsID);
					}
					else
					{
						wrapper = new ECWrapper(new Job_Seeker__c(ID = jsID, Name = jsName));
						wrappersByUserID.put(jsID, wrapper);
					}
					String ecResult = (String)result.get('Result__c');
					wrapper.incrementCalls(callCount.intValue(), ecResult);
				}

                JSPerfomance = wrappersByUserID.values();
                JSPerfomance.sort();
			}
			return JSPerfomance;
		}
		private set;
	}

	public void setDates()
	{
		try
    	{
    		throwTestError();
    		if(String.isBlank(SelectedPeriod))
    		{
    			return;
    		}
    		if(SelectedPeriod == '1')
    		{
    			fDate = Date.today().toStartOfWeek().addDays(-7);
    			tDate = fDate.addDays(6);
    		}
    		else if(SelectedPeriod == '2')
    		{
    			fDate = Date.today().toStartOfMonth().addMonths(-1);
    			tDate = fDate.addMonths(1).addDays(-1);
    		}
    		else if(SelectedPeriod == '3')
    		{
    			fDate = Date.today().toStartOfMonth().addMonths(-3);
    			tDate = fDate.addMonths(3).addDays(-1);
    		}
    		FromDate = fDate == null ? '' : fDate.format();
    		ToDate = tDate == null ? '' : tDate.format();
    	}
		catch(Exception ex)
		{
			addMessage(ex);
		}
	}

	public PageReference openReport()
	{
		try
    	{
    		throwTestError();
			String pageName = getParameter('rp');			
			PageReference pg = new PageReference(pageName);			
			pg.getParameters().put('f', FromDate);
			pg.getParameters().put('t', ToDate);		
			pg.getParameters().put('ec', SelectedECID);	
			return pg.setRedirect(true);
		}
		catch(Exception ex)
		{
			return addMessage(ex);
		}
	}
	public static void sendECReport(ID accID, Date fromDt, Date toDt)
	{
		sendECReport(accID, fromDt, toDt, false);
	}

	@future(callout=true)
    public static void sendECReport(ID accID, Date fromDt, Date toDt, Boolean includeUsers)
    {
        String emailAddresses = null;
        for(Account a : [SELECT ID,
                                EC_Report_Emails__c
                        FROM	Account
                        WHERE	ID = :accID])
        {
            emailAddresses = a.EC_Report_Emails__c;
        }
		if(includeUsers)
		{
			emailAddresses = addUsersEmailAddresses(accId, emailAddresses);
		}
		system.debug(emailAddresses);
        if(String.isBlank(emailAddresses))
        {
            return;
        }
        String fDate = fromDt.format();
        String tDate = toDt.format();
        PageReference pg = Page.BPReportECPerformance;
        pg.getParameters().put('f', fDate);
        pg.getParameters().put('t', tDate);
        pg.getParameters().put('acc', accID);

        Blob reportPdf = Test.isRunningTest() ? Blob.valueOf('Test') : pg.getContentAsPDF();
        List<Messaging.SingleEmailMessage> msgs = new List<Messaging.SingleEmailMessage>();
        for(String s : emailAddresses.split(';'))
        {
            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
            msg.setToAddresses(new String[]{s});
            msg.setSubject('EC performance report for ' + fDate + ' to ' + tDate);
            msg.setSenderDisplayName('BrokeredPlus');
            msg.setPlainTextBody('');

            Messaging.EmailFileAttachment att = new Messaging.EmailFileAttachment();
            att.setBody(reportPDF);
            att.setContentType('application/pdf');
            att.setFileName('ECPerfomanceReport-' + fDate + '-' + tDate + '.pdf');

            msg.setFileAttachments(new Messaging.EmailFileAttachment[]{att});
            msgs.add(msg);
        }
        Messaging.sendEmail(msgs);
    }

	public static void sendECActivityReport(ID accID, Date fromDt, Date toDt)
	{
		sendECActivityReport(accID, fromDt, toDt, false);
	}

    @future(callout=true)
    public static void sendECActivityReport(ID accID, Date fromDt, Date toDt, Boolean includeUsers)
	{
		String emailAddresses = null;
		List<String> sites = new List<String>{''};
		for(Account a : [SELECT ID,
								EC_Activity_Report_Emails__c,
								Sites__c,
								User_As_Worksheet_Site__c
						FROM Account
						WHERE ID = :accID])
		{
			emailAddresses = a.EC_Activity_Report_Emails__c;
            if(a.User_As_Worksheet_Site__c || includeUsers)
            {
                sites = null;
                emailAddresses = addUsersEmailAddresses(accId, emailAddresses);
            }
			else if(a.Sites__c != null)
			{
				sites = a.Sites__c.split(';');
			}
		}

		system.debug(emailAddresses);
		if(String.isBlank(emailAddresses))
		{
			return;
		}
        List< Messaging.EmailFileAttachment> attachments = new List< Messaging.EmailFileAttachment>();
        if(sites == null)
        {
            attachments.add(getECActivityAttachment(accID, null, fromDt, toDt));
        }
        else
        {
            for(String site : sites)
            {
                attachments.add(getECActivityAttachment(accID, site, fromDt, toDt));
            }
        }
        List<Messaging.SingleEmailMessage> msgs = new List<Messaging.SingleEmailMessage>();
        for(String s : emailAddresses.split(';'))
        {
            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
            msg.setToAddresses(new String[]{s});
            if(fromDt == toDt)
            {
                msg.setSubject('Activity report for ' + fromDt.format());
            }
            else
            {
                msg.setSubject('Activity report for ' + fromDt.format() + ' to ' + toDt.format());
            }
            msg.setSenderDisplayName('BrokeredPlus');
            msg.setPlainTextBody('');

            msg.setFileAttachments(attachments);
            msgs.add(msg);
        }
        Messaging.sendEmail(msgs);
    }

	private static Messaging.EmailFileAttachment getECActivityAttachment(ID accID, String site, Date fromDt, Date toDt)
	{
		PageReference pg = Page.BPReportSite;
		pg.getParameters().put('f', fromDt.format());
		pg.getParameters().put('t', toDt.format());
		pg.getParameters().put('acc', accID);
        pg.getParameters().put('site', site);

		Blob reportPdf = Test.isRunningTest() ? Blob.valueOf('Test') : pg.getContentAsPDF();

		Messaging.EmailFileAttachment att = new Messaging.EmailFileAttachment();
		att.setBody(reportPDF);
		att.setContentType('application/pdf');
		if(fromDt == toDt)
		{
			att.setFileName((site == null ? '' : site) + ' ActivityReport-' + fromDt.format() + '.pdf');
		}
		else
		{
			att.setFileName((site == null ? '' : site) + ' ActivityReport-' + fromDt.format() + '-' + toDt.format() + '.pdf');
		}
        return att;
	}

	private static String addUsersEmailAddresses(ID accID, String emailAddresses)
	{

		Set<String> existingEmails = new Set<String>(emailAddresses.split(';'));
		emailAddresses = emailAddresses == null ? '' : emailAddresses;
		if(!emailAddresses.endsWith(';'))
		{
			emailAddresses += ';';
		}
		for(User u : getAccountUsers(accId))
		{
			if(existingEmails.add(u.Email))
			{
				emailAddresses += u.Email + ';';
			}
		}
		return emailAddresses;
	}

	private static List<User> getAccountUsers(ID accID)
	{
		return [SELECT 	Name,
						Email
				FROM 	User
				WHERE 	AccountID = :accID AND
						IsActive = true];
	}

	private void getDates()
	{
		fDate = parseDate(getParameter('f'), Date.newInstance(2000, 1, 1));
		tDate = parseDate(getParameter('t'), Date.newInstance(2100, 1, 1));
		if(String.isBlank(getParameter('f')) || String.isBlank(getParameter('t')))
		{
			Days = '';
            ReportPeriod = 'All';
		}
		else
		{
			Integer daysBetween = fDate.daysBetween(tDate) + 1;
			Days = ' - ' + String.valueOf(daysBetween) + ' days';
            ReportPeriod = fDate.format() + ' - ' + tDate.format();
		}
		SelectedECID = getParameter('ec');
		FromDate = fDate.format();
		ToDate = tDate.format();
	}

	@TestVisible
	private Date parseDate(String s, Date defaultDate)
	{
		if(String.isBlank(s))
		{
			return defaultDate;
		}
		Date d = null;
		try
		{
			d = Date.parse(EncodingUtil.urlDecode(s, 'UTF-8'));
			return d;
		}
		finally
		{
			return d;
		}
	}

	private Set<Id> getUserIds(Date fDate, Date tDate)
	{
		Set<Id> userIds = new Set<Id>();
		if(String.isNotBlank(SelectedECID))
		{
			userIds.add(SelectedECID);
		}
		else
		{
			for(User u : [SELECT ID 
						FROM   	User
						WHERE 	AccountID = :CurrentAccount.ID AND 
								ID IN (SELECT User__c 
									FROM 	Employer_Contact__c 
									WHERE 	(Result__c != :BPConstants.EmployerContact_Result_Vacancy AND
											DAY_ONLY(convertTimezone(Contacted_On__c)) >= :fDate AND
											DAY_ONLY(convertTimezone(Contacted_On__c)) <= :tDate)
											OR 
											(Result__c = :BPConstants.EmployerContact_Result_Vacancy AND
											DAY_ONLY(convertTimezone(CreatedDate)) >= :fDate AND
											DAY_ONLY(convertTimezone(CreatedDate)) <= :tDate))])
			{
				userIds.add(u.ID);
			}
		}
		return userIds; 
	}

    private List<User> getAllUsers()
    {
        return [SELECT ID,
                        Name
                FROM   	User
                WHERE 	AccountID = :CurrentAccount.ID AND
                        IsActive = true];
    }

	private String getKPI(AggregateResult result)
	{
		return (String)result.get('kpi');
	}

	public class ECWrapper implements Comparable 
	{
		public ECWrapper(User u)
		{
			EC = u;
		}

        public ECWrapper(Job_Seeker__c js)
        {
            this.JS = js;
        }

        Integer dCalls = 0;
        Integer dResumeSent = 0;
        Integer dInterviews = 0;
        Integer dWorkTrials = 0;
        Integer dPlacements = 0;
        Integer dFailedToAttend = 0;
        Integer dVacancies = 0;

		public Integer compareTo(Object compareTo) 
		{
			ECWrapper ecToCompare = (ECWrapper)compareTo;
            if(EC != null)
            {
                return (EC.LastName == null ? 'z' : EC.LastName).compareTo(ecToCompare.EC.LastName == null ? 'z' : ecToCompare.EC.LastName);
            }
            if(JS != null)
            {
                return (JS.Name == null ? 'z' : JS.Name).compareTo(ecToCompare.JS.Name == null ? 'z' : ecToCompare.JS.Name);
            }
            return 0;
		}

		public User EC 
		{
			get;
			private set;
		}

        public Job_Seeker__c JS
        {
            get;
            private set;
        }


        public Integer Calls
        {
            get
            {
                return dCalls;
            }
        }

        public Integer ResumesSent
        {
            get
            {
                return dResumeSent;
            }
        }

        public Integer Interviews
        {
            get
            {
                return dInterviews;
            }
        }

        public Integer WorkTrials
        {
            get
            {
                return dWorkTrials;
            }
        }

        public Integer Placements
		{
			get
			{
				return dPlacements;
			}
		}

        public Integer FailedToAttend
        {
            get
            {
                return dFailedToAttend;
            }
        }

        public Integer Vacancies
		{
			get
			{
				return dVacancies;
			}
		}

        public void incrementCalls(Integer calls, String result) {
            calls = calls == null ? 0 : calls;
            dCalls += calls;
            if(result == BPConstants.EmployerContact_Result_ResumeSent ||
                    result == BPConstants.EmployerContact_Result_ResumeDropOff ||
                    result == BPConstants.EmployerContact_Result_Resume_Sent)
            {
                dResumeSent += calls;
            }
            else if(result == BPConstants.EmployerContact_Result_Interview)
            {
                dInterviews += calls;
            }
            else if(result == BPConstants.EmployerContact_Result_WorkTrial ||
                    result == 'Work experience')
            {
                dWorkTrials += calls;
            }
            else if(result == BPConstants.EmployerContact_Result_Placed)
            {
                dPlacements += calls;
            }
            else if(result == BPConstants.EmployerContact_Result_DeclinedEmployment ||
					result == BPConstants.EmployerContact_Result_FailedToAttend)
            {
                dFailedToAttend += calls;
            }
            else if(result == BPConstants.EmployerContact_Result_Vacancy)
            {
                dVacancies += calls;
            }
        }
	}

    public class ECPerfomanceTotal {
        public ECPerfomanceTotal(List<ECWrapper> wrappers) {
            Calls = 0;
            Interviews = 0;
            Vacancies = 0;
            Resumes = 0;
            Placements = 0;
            WorkTrials = 0;
            FailedToAttend = 0;

            for (ECWrapper w : wrappers) {
                Calls += w.Calls == null ? 0 : w.Calls;
                Resumes += w.ResumesSent == null ? 0 : w.ResumesSent;
                Interviews += w.Interviews == null ? 0 : w.Interviews;
                WorkTrials += w.WorkTrials == null ? 0 : w.WorkTrials;
                Placements += w.Placements == null ? 0 : w.Placements;
                FailedToAttend += w.FailedToAttend == null ? 0 : w.FailedToAttend;
                Vacancies += w.Vacancies == null ? 0 : w.Vacancies;
            }
        }

        public Integer Calls { get; set; }
        public Integer Interviews { get; set; }
        public Integer Vacancies { get; set; }
        public Integer Resumes { get; set; }
        public Integer Placements { get; set; }
        public Integer WorkTrials { get; set; }
        public Integer FailedToAttend { get; set; }
    }

    public class EmployerWrapper
    {
        public EmployerWrapper(Business__c b, Set<String> results)
        {
            Employer = b;
            ResultCountByResult = new Map<String, Integer>();
            for(String res : results)
            {
                ResultCountByResult.put(res, 0);
            }
            for(Employer_Contact__c ec : b.Employer_Contacts__r)
            {
                Integer i = ResultCountByResult.get(ec.Result_Display__c);
                ResultCountByResult.put(ec.Result_Display__c, ++i);
            }
        }
        public Business__c Employer{get;set;}
        public Map<String, Integer> ResultCountByResult{get;set;}
        public Integer Total
        {
            get
            {
                Integer total = 0;
                for(Integer i : ResultCountByResult.values())
                {
                    total += i;
                }
                return total;
            }
        }
    }
}