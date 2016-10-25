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

    /*public Integer TotalCalls
    {
    	get
    	{
    		TotalCalls = 0;
    		for(ECWrapper w : ECPerfomance)
    		{
    			TotalCalls += w.Calls;
    		}
    		return TotalCalls;
    	}
    	private set;
    }

    public Integer TotalMeetings
    {
    	get
    	{
    		TotalMeetings = 0;
    		for(ECWrapper w : ECPerfomance)
    		{
    			TotalMeetings += w.Meetings;
    		}
    		return TotalMeetings;
    	}
    	private set;
    }

    public Integer TotalVacancies
    {
    	get
    	{
    		TotalVacancies = 0;
    		for(ECWrapper w : ECPerfomance)
    		{
    			TotalVacancies += w.Vacancy;
    		}
    		return TotalVacancies;
    	}
    	private set;
    }

    public Integer TotalResumes
    {
    	get
    	{
    		TotalResumes = 0;
    		for(ECWrapper w : ECPerfomance)
    		{
    			TotalResumes += w.ResumesSent;
    		}
    		return TotalResumes;
    	}
    	private set;
    }

    public Integer TotalPlacements
    {
    	get
    	{
    		TotalPlacements = 0;
    		for(ECWrapper w : ECPerfomance)
    		{
    			TotalPlacements += w.Placements;
    		}
    		return TotalPlacements;
    	}
    	private set;
    }*/

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
									WHERE 	Result__c != :BPConstants.EmployerContact_Result_Vacancy AND 
											DAY_ONLY(Contacted_On__c) >= :fDate AND 
											DAY_ONLY(Contacted_On__c) <= :tDate
									ORDER BY Contacted_On__c),
									(SELECT Id, 
	      									Name,
	      									Actioned__c, 
	      									Address_Confirmed__c, 
	      									Assigned_To__c, 
	      									Action_Taken__c, 
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
									WHERE 	Due_Date__c >= :fDate AND 
											Due_Date__c <= :tDate
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
										Open_Vacancy__c,
										User__c,
										Job_Seeker__c,
										Job_Seeker__r.Name,
										Business__c, 
										Business__r.Name,
										CreatedDate,
										CreatedBy.Name
								FROM 	Employer_Contact__c
								WHERE 	Result__c = :BPConstants.EmployerContact_Result_Vacancy AND 
										DAY_ONLY(CreatedDate) >= :fDate AND 
										DAY_ONLY(CreatedDate) <= :tDate AND 
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
			if(ECPerfomance== null)
			{
				getDates();
				Map<ID, ECWrapper> wrappersByUserID = new Map<ID, ECWrapper>();
				for(AggregateResult result : [SELECT User__c,
													User__r.Name userName,
													User__r.Contact.Target__c  kpi,
													Result__c,
													COUNT(ID)  callCount
											FROM 	Employer_Contact__c
											WHERE 	User__c != null AND 
													Job_Seeker__r.Account__c = :CurrentAccount.ID AND
													Result__c != :(Test.isRunningTest() ? null : BPConstants.EmployerContact_Result_Vacancy) AND
													DAY_ONLY(Contacted_On__c) >= :fDate AND 
													DAY_ONLY(Contacted_On__c) <= :tDate 
											GROUP BY User__c, 
													User__r.Name,
													User__r.Contact.Target__c,
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
						wrapper = new ECWrapper(new User(ID = ecID, LastName = ecName, Target__c = getKPI(result)),
															callCount.intValue());
						wrappersByUserID.put(ecID, wrapper);
					}
					String ecResult = (String)result.get('Result__c');
					wrapper.incrementCalls(callCount.intValue(), ecResult);
					if(ecResult == Interview || ecResult == ResumeDropOff)
					{
						wrapper.incrementMeeting(callCount.intValue());
					}
				}
				for(AggregateResult result : [SELECT CreatedById,
													CreatedBy.Name userName,
													CreatedBy.Contact.Target__c kpi,
													Result__c,
													COUNT(ID)  callCount
											FROM 	Employer_Contact__c 
											WHERE 	Job_Seeker__r.Account__c = :CurrentAccount.ID AND 
													Result__c = :BPConstants.EmployerContact_Result_Vacancy AND
                                                    Live_Session__c = null AND
													DAY_ONLY(CreatedDate) >= :fDate AND 
													DAY_ONLY(CreatedDate) <= :tDate 
											GROUP BY CreatedById, 
													CreatedBy.Name,
													CreatedBy.Contact.Target__c,
													Result__c])
				{
					ID ecID = ID.valueOf((String)result.get('CreatedById'));
					String ecName = String.valueOf((String)result.get('userName'));
					Decimal callCount = (Decimal)result.get('callCount');
					ECWrapper wrapper;
					if(wrappersByUserID.containsKey(ecID))
					{
						wrapper = wrappersByUserID.get(ecID); 
					}
					else
					{
						wrapper = new ECWrapper(new User(ID = ecID, LastName = ecName, Target__c = getKPI(result)),
															callCount.intValue());
						wrappersByUserID.put(ecID, wrapper);
					}
					String ecResult = (String)result.get('Result__c');
					wrapper.incrementCalls(callCount.intValue(), ecResult);
				}
				for(AggregateResult result : [SELECT Assigned_To__c,
													Assigned_To__r.Name userName,
													Assigned_To__r.Contact.Target__c kpi,
													Action_Taken__c,
													COUNT(ID)  callCount
											FROM 	Follow_Up__c
											WHERE 	RecordType.Name = :BPConstants.FollowUp_RecordType_Followup AND
													Employer_Contact__r.Business__r.Account__c = :CurrentAccount.ID AND
													Assigned_To__c != null AND 
													Action_Taken__c IN ('Interview', 'Resume Drop off') AND
													Due_Date__c >= :fDate AND 
													Due_Date__c <= :tDate 
											GROUP BY Assigned_To__c, 
													Assigned_To__r.Name,
													Assigned_To__r.Contact.Target__c,
													Action_Taken__c])
				{
					ID ecID = ID.valueOf((String)result.get('Assigned_To__c'));
					String ecName = String.valueOf((String)result.get('userName'));
					Decimal callCount = (Decimal)result.get('callCount');
					ECWrapper wrapper;
					if(wrappersByUserID.containsKey(ecID))
					{
						wrapper = wrappersByUserID.get(ecID); 
					}
					else
					{
						wrapper = new ECWrapper(new User(ID = ecID, LastName = ecName, Target__c = getKPI(result)),
															callCount.intValue());
						wrappersByUserID.put(ecID, wrapper);
					}
					String ecResult = (String)result.get('Action_Taken__c');
					if(ecResult == Interview || ecResult == ResumeDropOff)
					{
						wrapper.incrementMeeting(callCount.intValue());
					}
				}
				for(AggregateResult result : [SELECT Assigned_To__c,
													Assigned_To__r.Name userName,
													Assigned_To__r.Contact.Target__c kpi,
													Closed__c,
													COUNT(ID)  followupCount
											FROM 	Follow_Up__c
											WHERE 	RecordType.Name = :BPConstants.FollowUp_RecordType_Followup AND
													Employer_Contact__r.Business__r.Account__c = :CurrentAccount.ID AND
													Assigned_To__c != null AND 
													Due_Date__c >= :fDate AND 
													Due_Date__c <= :tDate
											GROUP BY Assigned_To__c, 
													Assigned_To__r.Name,
													Assigned_To__r.Contact.Target__c,
													Closed__c])
				{
					ID ecID = ID.valueOf((String)result.get('Assigned_To__c'));
					String ecName = (String)result.get('userName');
					if(!wrappersByUserID.containsKey(ecID))
					{
						ECWrapper wrapper = new ECWrapper(new User(ID = ecID, LastName = ecName, Target__c = getKPI(result)));
						wrappersByUserID.put(ecID, wrapper);
					}
					Decimal followupCount = (Decimal)result.get('followupCount');
					Boolean isClosed = (Boolean)result.get('Closed__c');
					Integer closedCount = isClosed ? followupCount.intValue() : 0;
					wrappersByUserID.get(ecID).incrementFollowups(followupCount.intValue(), closedCount);
				}
				for(AggregateResult result : [SELECT Assigned_To__c,
													Assigned_To__r.Name userName,
													Assigned_To__r.Contact.Target__c kpi,
													COUNT(ID)  followupCount
											FROM 	Follow_Up__c
											WHERE 	RecordType.Name = :BPConstants.FollowUp_RecordType_Followup AND
													Employer_Contact__r.Business__r.Account__c = :CurrentAccount.ID AND
													Assigned_To__c != null AND 
													No_Further_Action_Required__c = true AND 
													Due_Date__c >= :fDate AND 
													Due_Date__c <= :tDate
											GROUP BY Assigned_To__c, 
													Assigned_To__r.Name,
													Assigned_To__r.Contact.Target__c,
													Closed__c])
				{
					ID ecID = ID.valueOf((String)result.get('Assigned_To__c'));
					String ecName = (String)result.get('userName');
					if(!wrappersByUserID.containsKey(ecID))
					{
						ECWrapper wrapper = new ECWrapper(new User(ID = ecID, LastName = ecName, Target__c = getKPI(result)));
						wrappersByUserID.put(ecID, wrapper);
					}
					Decimal followupCount = (Decimal)result.get('followupCount');
					if(followupCount != null)
					{
						wrappersByUserID.get(ecID).NoFurtherAction = followupCount.intValue();
					}
				}
                for(AggregateResult result : [SELECT Assigned_To__c,
													Assigned_To__r.Name userName,
													Assigned_To__r.Contact.Target__c kpi,
													COUNT(ID)  placedCount
											FROM 	Job_Seeker__c
											WHERE 	Account__c = :CurrentAccount.ID AND
													Assigned_To__c != null AND
                                                    Placed_Date__c >= :fDate AND 
													Placed_Date__c <= :tDate 
											GROUP BY Assigned_To__c, 
													Assigned_To__r.Name,
													Assigned_To__r.Contact.Target__c])
				{
					ID ecID = ID.valueOf((String)result.get('Assigned_To__c'));
					String ecName = (String)result.get('userName');
					if(!wrappersByUserID.containsKey(ecID))
					{
						ECWrapper wrapper = new ECWrapper(new User(ID = ecID, LastName = ecName, Target__c = getKPI(result)));
						wrappersByUserID.put(ecID, wrapper);
					}
					Decimal placedCount = (Decimal)result.get('placedCount');
					if(placedCount != null)
					{
						wrappersByUserID.get(ecID).incrementPacements(placedCount);
					}
				}
				if(CurrentUser.Marketing_Only__c)
				{
					for(Employer_Contact__c ec : [SELECT User__c,
                                                        User__r.Name,
                                                        User__r.Contact.Target__c,
                                                        Result__c,
                                                        Referral_From__c,
														Signups__c,
														(SELECT ID,
																Complete__c
														FROM 	Follow_Ups__r
														WHERE 	RecordType.Name = :BPConstants.FollowUp_RecordType_SignupComplete AND
                                                                Completed_Date__c >= :fDate AND
                                                                Completed_Date__c <= :tDate)
                                                FROM 	Employer_Contact__c
                                                WHERE 	User__c != null AND
														Job_Seeker__r.Account__c = :CurrentAccount.ID AND
                                                        (Result__c LIKE :('%' + BPConstants.EmployerContact_Result_Signup) OR
                                                        Result__c = :BPConstants.EmployerContact_Result_Referral) AND
														Live_Session__c = null AND
														DAY_ONLY(CreatedDate) >= :fDate AND
														DAY_ONLY(CreatedDate) <= :tDate])
					{
						if(!wrappersByUserID.containsKey(ec.User__c))
						{
							ECWrapper wrapper = new ECWrapper(new User(ID = ec.User__c, LastName = ec.User__r.Name, Target__c = ec.User__r.Contact.Target__c));
							wrappersByUserID.put(ec.User__c, wrapper);
						}
						wrappersByUserID.get(ec.User__c).incrementSignups(ec);
					}
				}
				ECPerfomance = wrappersByUserID.values();
				ECPerfomance.sort();
			}
			return ECPerfomance;
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

	@future(callout=true)
	public static void sendECReport(ID accID, Date fromDt, Date toDt)
	{
		String emailAddresses = null;
		for(Account a : [SELECT ID,
								EC_Report_Emails__c 
						FROM	Account 
						WHERE	ID = :accID])
		{
			emailAddresses = a.EC_Report_Emails__c;
		}
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

	private void getDates()
	{
		fDate = parseDate(getParameter('f'), Date.newInstance(2000, 1, 1));
		tDate = parseDate(getParameter('t'), Date.newInstance(2100, 1, 1));
		if(String.isBlank(getParameter('f')) || String.isBlank(getParameter('t')))
		{
			Days = '';
		}
		else
		{
			Integer daysBetween = fDate.daysBetween(tDate) + 1;
			Days = ' - ' + String.valueOf(daysBetween) + ' days';
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
											DAY_ONLY(Contacted_On__c) >= :fDate AND 
											DAY_ONLY(Contacted_On__c) <= :tDate) 
											OR 
											(Result__c = :BPConstants.EmployerContact_Result_Vacancy AND
											DAY_ONLY(CreatedDate) >= :fDate AND 
											DAY_ONLY(CreatedDate) <= :tDate))])
			{
				userIds.add(u.ID);
			}
		}
		return userIds; 
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

		public ECWrapper(User u, Integer calls)
		{
			EC = u;
			incrementCalls(calls, null);
		}

		Integer dPlacements = 0;
		Integer dMeetings = 0;
		Integer dFollowups = 0;
		Integer dFollowupsCompleted = 0;
		Integer dCalls = 0;
		Integer dNoAnswers = 0;
		Integer dResumeSent = 0;
		Integer dNoFurtherAction = 0;
		Integer dDisconnected = 0;
		Integer dNoVacancy = 0;
		Integer dVacancies = 0;

		Integer dAASNSignups = 0;
		Integer dAMPSignups = 0;
		Integer dAEPSignups = 0;
		Integer dSignupsComplete = 0;
		Integer dSignupsIncomplete = 0;

        Integer dReferrals = 0;

		public Integer compareTo(Object compareTo) 
		{
			ECWrapper ecToCompare = (ECWrapper)compareTo;
			return EC.LastName.compareTo(ecToCompare.EC.LastName); 
		}

		public User EC 
		{
			get;
			private set;
		}

		public Integer Placements 
		{
			get
			{
				return dPlacements;
			}
		}

		public Integer SignupsComplete
		{
			get
			{
				return dSignupsComplete;
			}
		}

		public Integer Referrals
		{
			get
			{
				return dReferrals;
			}
		}

        public Integer AASNSignups
        {
            get
            {
                return dAASNSignups;
            }
        }

        public Integer AMPSignups
        {
            get
            {
                return dAMPSignups;
            }
        }

        public Integer AEPSignups
        {
            get
            {
                return dAEPSignups;
            }
        }

        public Integer Signups
        {
            get
            {
                return dAEPSignups + dAMPSignups + dAASNSignups;
            }
        }

		public Integer Meetings
		{
			get
			{
				return dMeetings;
			}
		}

		public Integer NoFurtherAction
		{
			get
			{
				return dNoFurtherAction;
			}
			set
			{
				dNoFurtherAction = value;
			}
		}

		public Integer Followups
		{
			get
			{
				return dFollowups;
			}
		}

		public Integer FollowupsCompleted
		{
			get
			{
				return dFollowupsCompleted;
			}
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

		public Integer Disconnected 
		{
			get
			{
				return dDisconnected;
			}
		}

		public Integer NoVacancy 
		{
			get
			{
				return dNoVacancy;
			}
		}

		public Integer Vacancies
		{
			get
			{
				return dVacancies;
			}
		}

		public String MeetingRatio
		{
			get
			{
				return Calls == 0 ? 'N/A' : (((Meetings * 100) / (Calls * 1.0)).round().format() + '%');
			}
		}

		public String PlacementRatio
		{
			get
			{
				return Calls == 0 ? 'N/A' : (((Placements * 100) / (Calls * 1.0)).round().format() + '%');
			}
		}

		public String MeetingPlacementRatio
		{
			get
			{
				return dMeetings == 0 ? 'N/A' : (((Placements * 100) / (dMeetings * 1.0)).round().format() + '%');
			}
		}

		public String FollowupRatio
		{
			get
			{
				Decimal outstanding = Followups - FollowupsCompleted;
				return dFollowups == 0 ? 'N/A' : (((outstanding * 100.0) / (Followups * 1.0)).round().format() + '%');
			}
		}

		public String NoAnswerRatio
		{
			get
			{
				return dCalls == 0 ? 'N/A' : ((dNoAnswers * 100.0) / (dCalls * 1.0)).round().format() + '%';
			}
		}
		
		public String NoFurtherActionRatio
		{
			get
			{
				return dFollowups == 0 ? 'N/A' : ((dNoFurtherAction * 100.0) / (dFollowups * 1.0)).round().format() + '%';
			}
		}

		public String ResumeToMeetingRatio
		{
			get
			{
				return dMeetings == 0 ? 'N/A' : ((ResumesSent * 100.0) / (dMeetings * 1.0)).round().format() + '%';
			}
		}

		public void incrementCalls(Integer calls, String result)
        {
			dCalls += (calls == null ? 0 : calls);
			if(result == BPConstants.EmployerContact_Result_NoAnswer)
			{
				dNoAnswers += calls;
			}
			else if(result == BPConstants.EmployerContact_Result_ResumeSent)
			{
				dResumeSent += calls;
			}
			else if(result == BPConstants.EmployerContact_Result_Disconnected)
			{
				dDisconnected += calls;
			}
			else if(result == BPConstants.EmployerContact_Result_NoVacancy)
			{
				dDisconnected += calls;
			}
			else if(result == BPConstants.EmployerContact_Result_Vacancy)
			{
                dVacancies += calls;
			}
		}

		public void incrementFollowups(Integer followups, 
									Integer followupsCompleted)
		{
			dFollowups += (followups == null ? 0 : followups);
			dFollowupsCompleted += (followupsCompleted == null ? 0 : followupsCompleted);
		}

		public void incrementPacements(Decimal placements)
		{
			dPlacements += (placements == null ? 0 : placements.intValue());
		}

		public void incrementMeeting(Integer meetings)
		{
			dMeetings += (meetings == null ? 0 : meetings);
		}

		public void incrementSignups(Employer_Contact__c ec)
		{
            Integer signups = ec.Signups__c == null ? 0 : ec.Signups__c.intValue();
			if(ec.Result__c == BPConstants.EmployerContact_Result_Referral)
			{
				dReferrals += signups;
			}
			else
			{
				if(ec.Result__c == BPConstants.EmployerContact_Result_AASNSignup)
				{
					dAASNSignups += signups;
				}
				else if(ec.Result__c == BPConstants.EmployerContact_Result_AEPSignup)
				{
					dAEPSignups += signups;
				}
				else if(ec.Result__c == BPConstants.EmployerContact_Result_AMPSignup)
				{
					dAMPSignups += signups;
				}
                for(Follow_Up__c fu : ec.Follow_Ups__r)
                {
                    dSignupsComplete += fu.Complete__c == null ? 0 : fu.Complete__c.intValue();
                }
			}
		}
	}

    public class ECPerfomanceTotal {
        public ECPerfomanceTotal(List<ECWrapper> wrappers) {
            Calls = 0;
            Meetings = 0;
            Vacancies = 0;
            Resumes = 0;
            Placements = 0;
            Referrals = 0;
            Signups = 0;
            AASNSignups = 0;
            AMPSignups = 0;
            AEPSignups = 0;
            SignupsComplete = 0;
            for (ECWrapper w : wrappers) {
                Calls += w.Calls == null ? 0 : w.Calls;
                Meetings += w.Meetings == null ? 0 : w.Meetings;
                Vacancies += w.Vacancies == null ? 0 : w.Vacancies;
                Resumes += w.ResumesSent == null ? 0 : w.ResumesSent;
                Placements += w.Placements == null ? 0 : w.Placements;
                Referrals += w.Referrals == null ? 0 : w.Referrals;
                Signups += w.Signups == null ? 0 : w.Signups;
                SignupsComplete += w.SignupsComplete == null ? 0 : w.SignupsComplete;
                AASNSignups += w.AASNSignups == null ? 0 : w.AASNSignups;
                AMPSignups += w.AMPSignups == null ? 0 : w.AMPSignups;
                AEPSignups += w.AEPSignups == null ? 0 : w.AEPSignups;
            }
        }

        public Integer Calls { get; set; }
        public Integer Meetings { get; set; }
        public Integer Vacancies { get; set; }
        public Integer Resumes { get; set; }
        public Integer Placements { get; set; }
        public Integer Referrals { get; set; }
        public Integer Signups { get; set; }
		public Integer SignupsComplete { get; set; }
        public Integer AASNSignups { get; set; }
        public Integer AMPSignups { get; set; }
        public Integer AEPSignups { get; set; }
    }
}