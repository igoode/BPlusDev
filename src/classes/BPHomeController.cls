public with sharing class BPHomeController 
	extends BPPageBase
{
	public BPHomeController()
	{
	}

	public BPHomeController(BPCommunicationController o)
	{
	}

	public BPHomeController(ApexPages.StandardController ctrlr)
	{
		controller = ctrlr;
	}

	transient ApexPages.StandardController controller;
	transient List<Job_Seeker__c> tMyJobSeekers;
	transient List<Follow_Up__c> tMyFollowUps;
	transient List<Employer_Contact__c> tMyEmployerContacts;
	transient List<Job_Seeker__c> tJobSeekerSearchResults;
	transient List<Business__c> tEmployerSearchResults;	
	transient List<SelectOption> tAttributes;

	public Map<String, Report> ReportsByID
    {
        get {
            if(ReportsByID == null)
            {
                ReportsByID = new Map<String, Report>();
                for(Report rep :[SELECT ID,
                                        DeveloperName,
                                        Name
                                FROM    Report
                                WHERE   DeveloperName = 'Employer_Contact_Summary' OR
                                        DeveloperName = 'Results_Last_Week'])
                {
                    ReportsByID.put(rep.DeveloperName, rep);
                }
            }
            return ReportsByID;
        }
        private set;
    }

	public String JobSeekerSearch
	{
		get
		{
			if(JobSeekerSearch == null)
			{
				return '';
			}
			return JobSeekerSearch;
		}
		set;
	}

	public String AttributeSearch
	{
		get;
		set;
	}

	public String AttributeSearch2
	{
		get;
		set;
	}

	public Date FromDate 
	{
		get; 
		set; 
	}

	public Date ToDate 
	{
		get; 
		set; 
	}

	public List<SelectOption> Attributes 
	{
		get 
		{
			if (tAttributes == null)
			{
				tAttributes = getSelectListFromObjectList(JobSeekerAttributes, 'Name', 'Name', true);
			}
			return tAttributes;
		}
	}

	public List<Job_Seeker__c> MyJobSeekers
	{
		get
		{
			if(tMyJobSeekers == null)
			{
                tMyJobSeekers = [SELECT ID,
                                                Name,
                                                Email__c,
                                                Marketing_Started__c,
                                                Last_Marketed_Searched_On__c,
                                                Assigned_To__c,
                                                BrokeredLive__c,
                                                (SELECT ID,
                                                        Contacted_On__c
                                                FROM    Employer_Contacts__r
                                                ORDER BY Contacted_On__c DESC
                                                LIMIT 1)
                                        FROM 	Job_Seeker__c
                                        WHERE 	(Assigned_To__c = null OR
                                                Assigned_To__c = :UserInfo.getUserId())
                                        ORDER BY Last_Marketed_Searched_On__c DESC NULLS LAST
                                        LIMIT 11];
			}
			return tMyJobSeekers;
		}
	}

	public List<Job_Seeker__c> JobSeekerSearchResults
	{
		get
		{
			if(tJobSeekerSearchResults == null)
			{
				tJobSeekerSearchResults = new List<Job_Seeker__c>();
			}
			return tJobSeekerSearchResults;
		}
	}

	public List<Business__c> EmployerSearchResults
	{
		get
		{
			if(tEmployerSearchResults == null)
			{
				tEmployerSearchResults = new List<Business__c>();
			}
			return tEmployerSearchResults;
		}
	}

	public List<Follow_Up__c> MyFollowUps
	{
		get
		{
			if(tMyFollowUps == null)
			{
				tMyFollowUps = [SELECT ID,
										Name,
										Due_Date__c,
										Due_Time__c,
										Job_Seeker__c,
										Employer__c,
										Type__c,
										Contact_Number__c,
										Email__c,
										Overdue__c,
                                        Add_To_Outlook__c,
										Job_Seeker__r.Name,
										Employer_Contact__c,
										Employer_Contact__r.Result__c,
										Employer_Contact__r.Contact_Number__c,
										Employer_Contact__r.Business__r.Name
								FROM 	Follow_Up__c
								WHERE 	(Employer_Contact__r.User__c = :UserInfo.getUserId() OR
										Assigned_To__c = :UserInfo.getUserId()) AND 
										Actioned__c = null AND
										No_Further_Action_Required__c = false AND
										Due_Date__c <= :Date.today()
								ORDER BY Due_Date__c
								LIMIT 11];
			}
			return tMyFollowUps;
		}
	}

	public List<Employer_Contact__c> MyEmployerContacts
	{
		get
		{
			if(tMyEmployerContacts == null)
			{
				tMyEmployerContacts = [SELECT ID,
												Name,
												Contacted_On__c,
												Contact_Email__c,
												Contact_Number__c,
												Result__c,
												Job_Seeker__c,
												Job_Seeker__r.Name,
												Job_Seeker__r.Marketing_Started__c,
												Business__r.Name
										FROM 	Employer_Contact__c
										WHERE 	User__c = :UserInfo.getUserId() 
										ORDER BY Contacted_On__c DESC
										LIMIT 11];
			}
			return tMyEmployerContacts;
		}
	}

	public PageReference searchJS()
	{
		try
		{
			if(!IsManager && String.isBlank(JobSeekerSearch.trim()))
			{
				for(Employer_Contact__c ec : [SELECT Job_Seeker__r.Name
											FROM 	Employer_Contact__c
											WHERE 	User__c = :UserInfo.getUserId()
											ORDER BY Contacted_On__c DESC
											LIMIT 1])
				{
					JobSeekerSearch = ec.Job_Seeker__r.Name;
				}
			}
			tJobSeekerSearchResults = [SELECT ID,
											Name,
											Email__c,
											Marketing_Started__c,
											Marketing_Ended__c,
											BrokeredLive__c,
											Assigned_to__c,
                                            Last_Marketed_Searched_On__c,
											Assigned_To__r.Name
									FROM 	Job_Seeker__c
									WHERE 	//(
											//	Assigned_To__c = :UserInfo.getUserId() OR
											//	Name LIKE :(IsManager ? '%' : '~')
											//) AND
											(
												Name LIKE :('%' + JobSeekerSearch.trim() + '%')
											)									
									LIMIT 11];	
			if(controller == null)
			{
				List<Business__c> userBusinesses = [SELECT ID
													 FROM 	Business__c
													 WHERE 	Name LIKE :('%' + JobSeekerSearch.trim() + '%') OR
													 		ABN__c = :JobSeekerSearch.trim()
													 /*AND ID IN (SELECT 	Business__c 
													 				FROM 	Employer_Contact__c 
													 				WHERE 	User__c = :CurrentUser.ID  OR 
																			Name LIKE :(IsManager ? '%' : '~'))*/
											 		LIMIT 11];											
				tEmployerSearchResults = [SELECT ID,
												 Name,
												 Location__c,
												 Last_Contacted__c,
												 Last_Contacted_By__c,
												 Last_Contacted_By__r.Name,
												 Do_Not_Disturb_Expiry__c
										 FROM 	Business__c
										 WHERE 	(Name LIKE :('%' + JobSeekerSearch.trim() + '%') OR
										 		ABN__c = :JobSeekerSearch.trim()) AND
										 		(
									 				ID IN :userBusinesses OR 
										 			Last_Contacted_By__c = :CurrentUser.ID 
									 			)];
			}									
			return null;
		}
		catch(Exception ex)
		{
			return addMessage(ex);
		}
	}


	public void searchAttr()
	{
		try
		{
			String attr1 = String.isBlank(AttributeSearch) ? '~' : AttributeSearch.trim();
			String attr2 = String.isBlank(AttributeSearch2) ? '~' : AttributeSearch2.trim();
			tJobSeekerSearchResults = [SELECT ID,
											Name,
											Email__c,
											Marketing_Started__c,
											Marketing_Ended__c,
											BrokeredLive__c,
											Assigned_to__c,
											Assigned_To__r.Name
									FROM 	Job_Seeker__c
									WHERE 	(
												X1_Marketable_Attribute__c = :attr1 OR
												X2_Marketable_Attribute__c = :attr1 OR
												X3_Marketable_Attribute__c = :attr1
											)	
											OR
											(
												X1_Marketable_Attribute__c LIKE :('%' + attr2 + '%') OR
												X2_Marketable_Attribute__c LIKE :('%' + attr2 + '%') OR
												X3_Marketable_Attribute__c LIKE :('%' + attr2 + '%') 
											)									
									LIMIT 11];	
		}
		catch(Exception ex)
		{
			addMessage(ex);
		}
	}

	public PageReference checkCredentials()
	{
		if(UserInfo.getUserType() == 'Guest' || String.isBlank(UserInfo.getSessionId()))
		{
			PageReference pg = Page.BPLogin;
			return pg.setRedirect(true);
		}
//		for(User u : [SELECT ID,
//							Contact.Account.Use_Worksheet__c
//					FROM    User
//					WHERE 	ID = :UserInfo.getUserId()])
//		{
//			if(u.Contact.Account.Use_Worksheet__c)
//			{
//				return Page.BPWorksheet;
//			}
//		}
		return null;
	}
}