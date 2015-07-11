public with sharing class BPReports 
	extends BPPageBase
{
    public BPReports()
    {
    }

    private transient List<Job_Seeker__c> tJobSeekers;
    private transient List<User> tECs;
    private Date fDate;
    private Date tDate;

    public Boolean ECOnly 
    {
    	get
    	{
    		return CurrentUser.Profile.Name == BPConstants.Profile_BPlusCommunity;
    	}
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

    public Integer TotalCalls
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
														WHERE 	AccountID != null]);
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

    public Job_Seeker__c JobSeeker
	{
		get
		{							
			if(JobSeeker == null)
			{
				String jobSeekerID = getParameter('jskId');
				JobSeeker = [SELECT Id, 
  									Name, 
  									Account__c, 
  									Address_Location__c, 
  									Email__c, 
  									JSK_ID__c,  
  									Marketing_Ended__c, 
  									Marketing_Outcome__c, 
  									Marketing_Started__c, 
  									Marketing_Start_Date__c,
  									Days_Marketed__c,
  									Mobile__c, 
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
  											Result__c, 
  											Sensis_ID__c, 
  											User__c,
					                        Job_Seeker__c,
					                        Job_Seeker__r.Name,
					                        Business__c, 
					                        Business__r.Name,
					                        User__r.Name
									FROM 	Employer_Contacts__r
									WHERE 	DAY_ONLY(Contacted_On__c) >= :fDate AND 
											DAY_ONLY(Contacted_On__c) <= :tDate
									ORDER BY Contacted_On__c),
									(SELECT Id, 
          									Name,          									 
          									Actioned__c, 
          									Address_Confirmed__c, 
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
			return JobSeeker;
		}
		private set;
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
	  									JSK_ID__c,  
	  									Marketing_Ended__c, 
	  									Marketing_Outcome__c, 
	  									Marketing_Started__c, 
	  									Marketing_Start_Date__c,
	  									Days_Marketed__c,
	  									Mobile__c, 
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
	  											Result__c, 
	  											Sensis_ID__c, 
	  											User__c,
						                        Job_Seeker__c,
						                        Job_Seeker__r.Name,
						                        Business__c, 
						                        Business__r.Name,
						                        User__r.Name
										FROM 	Employer_Contacts__r
										WHERE 	DAY_ONLY(Contacted_On__c) >= :fDate AND 
												DAY_ONLY(Contacted_On__c) <= :tDate
										ORDER BY Contacted_On__c),
										(SELECT Id, 
	          									Name,
	          									Actioned__c, 
	          									Address_Confirmed__c, 
	          									Assigned_To__c, 
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
				List<ID> userIds = new List<ID>();		
				if(String.isNotBlank(SelectedECID))
				{
					userIds.add(SelectedECID);
				}
				else
				{
					for(User u : [SELECT ID 
								FROM   	User
								WHERE 	AccountID != null AND 
										ID IN (SELECT User__c 
											FROM 	Employer_Contact__c 
											WHERE 	DAY_ONLY(Contacted_On__c) >= :fDate AND 
													DAY_ONLY(Contacted_On__c) <= :tDate)])
					{
						userIds.add(u.ID);
					}
				}

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
									WHERE 	DAY_ONLY(Contacted_On__c) >= :fDate AND 
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
						WHERE 	ID IN :userIds
						ORDER BY Name]; 
			}
			return tECs;
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
													Result__c,
													COUNT(ID)  callCount
											FROM 	Employer_Contact__c 
											WHERE 	User__c != null AND 
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
						wrapper = new ECWrapper(new User(ID = ecID, LastName = ecName),
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
				for(AggregateResult result : [SELECT Assigned_To__c,
													Assigned_To__r.Name userName,
													Closed__c,
													COUNT(ID)  followupCount
											FROM 	Follow_Up__c
											WHERE 	Assigned_To__c != null AND 
													Due_Date__c >= :fDate AND 
													Due_Date__c <= :tDate
											GROUP BY Assigned_To__c, 
													Assigned_To__r.Name,
													Closed__c])
				{
					ID ecID = ID.valueOf((String)result.get('Assigned_To__c'));
					String ecName = (String)result.get('userName');
					if(!wrappersByUserID.containsKey(ecID))
					{
						ECWrapper wrapper = new ECWrapper(new User(ID = ecID, LastName = ecName));
						wrappersByUserID.put(ecID, wrapper);
					}
					Decimal followupCount = (Decimal)result.get('followupCount');
					Boolean isClosed = (Boolean)result.get('Closed__c');
					Integer closedCount = isClosed ? followupCount.intValue() : 0;
					wrappersByUserID.get(ecID).incrementFollowups(followupCount.intValue(), closedCount);
				}
				for(AggregateResult result : [SELECT Assigned_To__c,
													Assigned_To__r.Name userName,
													COUNT(ID)  followupCount
											FROM 	Follow_Up__c
											WHERE 	Assigned_To__c != null AND 
													No_Further_Action_Required__c = true AND 
													Due_Date__c >= :fDate AND 
													Due_Date__c <= :tDate
											GROUP BY Assigned_To__c, 
													Assigned_To__r.Name,
													Closed__c])
				{
					ID ecID = ID.valueOf((String)result.get('Assigned_To__c'));
					String ecName = (String)result.get('userName');
					if(!wrappersByUserID.containsKey(ecID))
					{
						ECWrapper wrapper = new ECWrapper(new User(ID = ecID, LastName = ecName));
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
													COUNT(ID)  followupCount
											FROM 	Follow_Up__c
											WHERE 	Assigned_To__c != null AND 
													Due_Date__c >= :fDate AND 
													Due_Date__c <= :tDate AND 
													Type__c = :BPConstants.FollowUp_Type_WageSubsidySent
											GROUP BY Assigned_To__c, 
													Assigned_To__r.Name])
				{
					ID ecID = ID.valueOf((String)result.get('Assigned_To__c'));
					String ecName = (String)result.get('userName');
					if(!wrappersByUserID.containsKey(ecID))
					{
						ECWrapper wrapper = new ECWrapper(new User(ID = ecID, LastName = ecName));
						wrappersByUserID.put(ecID, wrapper);
					}
					Decimal wageSubCount = (Decimal)result.get('followupCount');
					if(wageSubCount != null)
					{
						wrappersByUserID.get(ecID).WageSubsidies = wageSubCount.intValue();
					}
				}
				for(AggregateResult result : [SELECT Assigned_To__c,
													Assigned_To__r.Name userName,													
													COUNT(ID)  placedCount
											FROM 	Job_Seeker__c
											WHERE 	Assigned_To__c != null AND 
													Placed_Date__c != null AND 
													Placed_Date__c >= :fDate AND 
													Placed_Date__c <= :tDate
											GROUP BY Assigned_To__c, 
													Assigned_To__r.Name])
				{
					ID ecID = ID.valueOf((String)result.get('Assigned_To__c'));
					String ecName = (String)result.get('userName');
					if(!wrappersByUserID.containsKey(ecID))
					{
						ECWrapper wrapper = new ECWrapper(new User(ID = ecID, LastName = ecName));
						wrappersByUserID.put(ecID, wrapper);
					}
					Decimal placedCount = (Decimal)result.get('placedCount');
					wrappersByUserID.get(ecID).incrementPacements(placedCount.intValue());
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

	private void getDates()
	{
		fDate = parseDate(getParameter('f'), Date.newInstance(2000, 1, 1));
		tDate = parseDate(getParameter('t'), Date.newInstance(2100, 1, 1));
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
		Integer dVacancy = 0;
		Integer dWageSubsidies = 0;

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

		public Integer Vacancy 
		{
			get
			{
				return dVacancy;
			}
		}

		public Integer WageSubsidies 
		{
			get
			{
				return dWageSubsidies;
			}
			set 
			{
				dWageSubsidies = value;
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
				dVacancy += calls;
			}
		}

		public void incrementFollowups(Integer followups, 
									Integer followupsCompleted)
		{
			dFollowups += (followups == null ? 0 : followups);
			dFollowupsCompleted += (followupsCompleted == null ? 0 : followupsCompleted);
		}

		public void incrementPacements(Integer placements)
		{
			dPlacements += (placements == null ? 0 : placements);
		}

		public void incrementMeeting(Integer meetings)
		{
			dMeetings += (meetings == null ? 0 : meetings);
		}
	}
}