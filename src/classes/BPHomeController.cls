public with sharing class BPHomeController 
	extends BPPageBase
{
	public BPHomeController()
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

	public String JobSeekerSearch
	{
		get;
		set;
	}

	public List<Job_Seeker__c> MyJobSeekers
	{
		get
		{
			if(tMyJobSeekers == null)
			{
				tMyJobSeekers = [SELECT ID,
										Name,
										Mobile__c,
										Email__c,
										JSK_ID__c,
										Marketing_Started__c,
										Assigned_To__c
								FROM 	Job_Seeker__c
								WHERE 	Assigned_To__c = :UserInfo.getUserId() AND 
										Marketing_Ended__c = null
								ORDER BY Marketing_Started__c DESC NULLS LAST
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
										Job_Seeker__c,
										Employer__c,
										Type__c,
										Contact_Number__c,
										Email__c,
										Overdue__c,
										Job_Seeker__r.Name,
										Employer_Contact__c,
										Employer_Contact__r.Result__c,
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
			tJobSeekerSearchResults = [SELECT ID,
											Name,
											Mobile__c,
											Email__c,
											JSK_ID__c,
											Marketing_Started__c,
											Marketing_Ended__c,
											Assigned_to__c,
											Assigned_To__r.Name
									FROM 	Job_Seeker__c
									WHERE 	(
												Assigned_To__c = :UserInfo.getUserId() OR 
												Name LIKE :(IsManager ? '%' : '~')
											) AND 
											(
												Name LIKE :('%' + JobSeekerSearch + '%') OR
												JSK_ID__c LIKE :('%' + JobSeekerSearch + '%')
											)
									LIMIT 11];	
			if(controller == null)
			{
				List<Business__c> userBusinesses = [SELECT ID
													 FROM 	Business__c
													 WHERE 	Name LIKE :('%' + JobSeekerSearch + '%') AND 
													 		ID IN (SELECT 	Business__c 
													 				FROM 	Employer_Contact__c 
													 				WHERE 	User__c = :CurrentUser.ID  OR 
																			Name LIKE :(IsManager ? '%' : '~'))
											 		LIMIT 11];											
				tEmployerSearchResults = [SELECT ID,
												 Name,
												 Location__c,
												 Last_Contacted__c,
												 Last_Contacted_By__c,
												 Last_Contacted_By__r.Name,
												 Do_Not_Disturb_Expiry__c
										 FROM 	Business__c
										 WHERE 	Name LIKE :('%' + JobSeekerSearch + '%') AND 
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

	public PageReference checkCredentials()
	{
		if(UserInfo.getUserType() == 'Guest' || String.isBlank(UserInfo.getSessionId()))
		{
			PageReference pg = Page.BPLogin;
			return pg.setRedirect(true);
		}
		return null;
	}
}