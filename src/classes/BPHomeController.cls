public with sharing class BPHomeController 
	extends BPPageBase
{
	public BPHomeController()
	{
	}

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
										Marketing_Ended__c = null];
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
										Employer_Contact__c,
										Contact_Number__c,
										Email__c,
										Job_Seeker__r.Name
								FROM 	Follow_Up__c
								WHERE 	(Employer_Contact__r.User__c = :UserInfo.getUserId() OR
										Assigned_To__c = :UserInfo.getUserId()) AND 
										Actioned__c = null AND
										Due_Date__c <= :Date.today()
								ORDER BY Due_Date__c];
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
												Job_Seeker__c,
												Job_Seeker__r.Name,
												Job_Seeker__r.Marketing_Started__c,
												Business__r.Name
										FROM 	Employer_Contact__c
										WHERE 	User__c = :UserInfo.getUserId() 
										ORDER BY Contacted_On__c DESC];
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
											Assigned_to__c
									FROM 	Job_Seeker__c
									WHERE 	Assigned_To__c = :UserInfo.getUserId() AND 
											(
												Name LIKE :('%' + JobSeekerSearch + '%') OR
												JSK_ID__c LIKE :('%' + JobSeekerSearch + '%')
											)];	
			
			List<Business__c> userBusinesses = [SELECT ID
												 FROM 	Business__c
												 WHERE 	Name LIKE :('%' + JobSeekerSearch + '%') AND 
												 		ID IN (SELECT 	Business__c 
												 				FROM 	Employer_Contact__c 
												 				WHERE 	User__c = :CurrentUser.ID)];											
			tEmployerSearchResults = [SELECT ID,
											 Name,
											 Last_Contacted__c,
											 Last_Contacted_By__c,
											 Do_Not_Disturb_Expiry__c
									 FROM 	Business__c
									 WHERE 	Name LIKE :('%' + JobSeekerSearch + '%') AND 
									 		(
								 				ID IN :userBusinesses OR 
									 			Last_Contacted_By__c = :CurrentUser.ID
								 			)];									
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