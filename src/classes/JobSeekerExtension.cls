public with sharing class JobSeekerExtension 
    extends BPPageBase
{
    public JobSeekerExtension(ApexPages.StandardController ctrlr) 
    {
        if(!Test.isRunningTest())
        {
            ctrlr.addFields(new String[]{'Assigned_To__c','Marketing_Ended__c','Account__c','X1_Marketable_Attribute__c','X2_Marketable_Attribute__c','X3_Marketable_Attribute__c'});
        }    	
        controller = ctrlr;
    }

    private ApexPages.StandardController controller;

    public List<Employer_Contact__c> EmployerContacts 
    {
    	get 
    	{
    		if(EmployerContacts == null)
    		{
    			EmployerContacts = [SELECT Id, 
    										Name, 
    										Contacted_On__c, 
    										Result__c, 
    										User__c, 
    										Contact_Number__c, 
    										Contact_Email__c, 
    										Interview_Time__c, 
                                            Interview_Date__c,
    										Sensis_ID__c, 
    										Contact_Person__c, 
    										Contact_Position__c,
                                            Category__c,
                                            Comment__c,
    										Business__c,
                                            Business__r.Name,
                                            User__r.Name,
                                            Job_Seeker__c,
                                            Job_Seeker__r.Name
									FROM 	Employer_Contact__c
									WHERE 	Job_Seeker__c = :controller.getId() AND 
                                            Live_Session__c = null 
									ORDER BY Contacted_On__c DESC NULLS LAST];
    		}
    		return EmployerContacts;
    	}
    	private set;
    }

    public List<SelectOption> Sites
    {
        get
        {
            if(Sites == null)
            {
                Sites = new List<SelectOption>();
                String allSites = CurrentUser.Contact.Account.Sites__c;
                if(allSites != null)
                {
                    Sites.add(new SelectOption('', '--None--'));
                    for(String s : allSites.split(';'))
                    {
                        Sites.add(new SelectOption(s, s));
                    }
                }
            }
            return Sites;
        }
        private set;
    }

    public List<Follow_Up__c> FollowUpsDone
    {
        get 
        {
            if(FollowUpsDone == null)
            {
                FollowUpsDone = [SELECT Id, 
                                    Name,
                                    Employer_Contact__c, 
                                    Due_Date__c, 
                                    Due_Time__c,
                                    Type__c, 
                                    Actioned__c, 
                                    Contact_Number__c, 
                                    Email__c, 
                                    Action_Taken__c,
                                    Interview_Time__c, 
                                    Interview_Date__c,
                                    Comment__c,
                                    Employer__c,
                                    Regarding__c,
                                    Employer_Contact_Person__c, 
                                    Employer_Contact_Position__c, 
                                    Result__c, 
                                    No_Further_Action_Required__c,
                                    Employer_Contact__r.Result__c,
                                    Employer_Contact__r.Contact_Number__c,
                                    Employer_Contact__r.Business__c,
                                    Assigned_To__c,
                                    Assigned_To__r.Name
                            FROM    Follow_Up__c
                            WHERE   Job_Seeker__c = :controller.getId() AND 
                                    Actioned__c != null    
                            ORDER BY Actioned__c DESC NULLS LAST];
            }
            return FollowUpsDone;
        }
        private set;
    }

    public List<Follow_Up__c> FollowUpsToDo
    {
        get 
        {
            if(FollowUpsToDo == null)
            {
                FollowUpsToDo = [SELECT Id, 
                                    Name,
                                    Employer_Contact__c, 
                                    Due_Date__c, 
                                    Due_Time__c,
                                    Type__c, 
                                    Actioned__c, 
                                    Contact_Number__c, 
                                    Email__c, 
                                    Action_Taken__c,
                                    Interview_Time__c, 
                                    Interview_Date__c,
                                    Comment__c,
                                    Employer__c,
                                    Employer_Contact_Person__c, 
                                    Employer_Contact_Position__c, 
                                    Result__c, 
                                    Regarding__c,
                                    No_Further_Action_Required__c,
                                    Employer_Contact__r.Result__c,
                                    Employer_Contact__r.Contact_Number__c,
                                    Employer_Contact__r.Business__c,
                                    Assigned_To__c,
                                    Assigned_To__r.Name
                            FROM    Follow_Up__c
                            WHERE   Job_Seeker__c = :controller.getId() AND 
                                    Actioned__c = null  
                            ORDER BY Due_Date__c DESC NULLS LAST];
            }
            return FollowUpsToDo;
        }
        private set;
    }

    public List<Communication__c> Subsidies 
    {
        get
        {
                if(Subsidies == null)
                {
                    Subsidies = [SELECT CreatedDate,
                                        EC__r.Name,
                                        Employer__c,
                                        Sent__c,
                                        (SELECT ID 
                                        FROM    Attachments)
                                FROM    Communication__c
                                WHERE   Job_Seeker__c = :controller.getId() AND 
                                        RecordType.Name = :BPConstants.Communication_RecordType_WageSubsidy
                                ORDER BY Sent__c DESC];
                }
                return Subsidies;
        }
        private set;
    }

    public List<Communication__c> SMSMessages 
    {
        get
        {
                if(SMSMessages == null)
                {
                    SMSMessages = [SELECT Delivered__c,
                                        Delivery_Status__c,
                                        Message__c,
                                        Type__c,
                                        Sent__c
                                FROM    Communication__c
                                WHERE   RecordType.Name = :BPConstants.Communication_RecordType_SMSNotification AND
                                        Job_Seeker__c = :controller.getId()
                                ORDER BY Sent__c DESC];
                }
                return SMSMessages;
        }
        private set;
    }

    public PageReference checkAttributes()
    {
        try
        {
            throwTestError();
            Job_Seeker__c jSeeker = (Job_Seeker__c)controller.getRecord();
            if(getParameter('redirect') == 'no')
            {
                return null;
            }
            if(String.isEmpty(jSeeker.X1_Marketable_Attribute__c) ||
                    String.isEmpty(jSeeker.X2_Marketable_Attribute__c) ||
                    String.isEmpty(jSeeker.X3_Marketable_Attribute__c))
            {
                return null;
            }
            PageReference pg = Page.EmployerSearch;
            pg.getParameters().put('id', jSeeker.ID);
            return pg.setRedirect(true);
        }
        catch(Exception ex)
        {
            return addMessage(ex);
        }
    }

    public PageReference saveAndCommenceMarketing()
    {
        Savepoint sp = Database.setSavepoint();
        try
        {
            throwTestError();
            Job_Seeker__c jSeeker = (Job_Seeker__c)controller.getRecord();
            saveOverride();
            if(commenceMarketing() == null)
            {
                if(sp != null)
                {
                    Database.rollback(sp);
                }
                return null;
            }
            PageReference pg = Page.EmployerSearch;
            pg.getParameters().put('id', jSeeker.ID);
            return pg.setRedirect(true);
        }
        catch(Exception ex)
        {
            return addMessage(ex, sp);
        }
    }


    public PageReference commenceMarketing()
    {
        try
        {
            throwTestError();
            Job_Seeker__c jSeeker = (Job_Seeker__c)controller.getRecord();
            if(String.isEmpty(jSeeker.X1_Marketable_Attribute__c) ||
                    String.isEmpty(jSeeker.X2_Marketable_Attribute__c) ||
                    String.isEmpty(jSeeker.X3_Marketable_Attribute__c))
            {
                return addMessage('3 Most Marketable Attributes are required before commencing marketing.');
            }
            update jSeeker;
            PageReference pg = Page.EmployerSearch;
            pg.getParameters().put('id', jSeeker.ID);
            return pg.setRedirect(true);
        }
        catch(Exception ex)
        {
            return addMessage(ex);
        }
    }

    public PageReference saveOverride()
    {
        try
        {
            throwTestError();   
            Job_Seeker__c jSeeker = (Job_Seeker__c)controller.getRecord();  
            Boolean newRecord = jSeeker.ID == null;  
            if(String.isBlank(jSeeker.Account__c) && CurrentUser.ContactID != null)
            {
                jSeeker.Account__c = CurrentUser.Contact.AccountID;
            }             
            if(jSeeker.Marketing_Ended__c == null && jSeeker.Assigned_To__c == null)
            {
                jSeeker.Assigned_To__c = CurrentUser.ID;
            }  
            if(jSeeker.Placed_Date__c == null || jSeeker.Placed_With__c == null)
            {
                jSeeker.Placed_Date__c = null;
                jSeeker.Placed_With__c = null;
            }
            Boolean valid = true; 
            valid = isRequiredFieldValid(jSeeker.Suburb__c, 'Suburb', valid);
            valid = isRequiredFieldValid(jSeeker.State__c, 'State', valid);
            if(CurrentUser.Contact.Account.Sites__c != null)
            {
                valid = isRequiredFieldValid(jSeeker.Site__c, 'Site', valid);
            }
            if(jSeeker.BrokeredLive__c && (Test.isRunningTest() || CurrentUser.BrokeredLive__c))
            {
                valid = isRequiredFieldValid(jSeeker.BrokeredLive_Username__c, 'BrokeredLive Username', valid);
                valid = isRequiredFieldValid(jSeeker.BrokeredLive_Phrase_Prompt__c, 'Password Prompt', valid);
                valid = isRequiredFieldValid(jSeeker.BrokeredLive_Phrase__c, 'BrokeredLive Password', valid);
                if(String.isNotBlank(jSeeker.BrokeredLive_Username__c) && jSeeker.BrokeredLive_Username__c.length() < 6)
                {
                    addMessage('Username must be at least 6 characters.');
                    valid = false;
                }
                if(String.isNotBlank(jSeeker.BrokeredLive_Phrase__c) && jSeeker.BrokeredLive_Phrase__c.length() < 6)
                {
                    addMessage('Password must be at least 6 characters.');
                    valid = false;
                }
                if(valid)
                {
                    BPJobSeekerNoSharing.checkBrokeredLiveUserName(jSeeker);
                }
            }
            if(!valid)
            {
                return null;
            }
            upsert jSeeker;
            if(newRecord)
            {
                PageReference pg = Page.JobSeekerEdit;
                pg.getParameters().put('id', jSeeker.ID);
                return pg.setRedirect(true); 
            }
            return null;
        }
        catch(Exception ex)
        {
            return addMessage(ex);
        }
    }

    public void checkBrokeredLiveUsername()
    {
        try
        {
            Job_Seeker__c jSeeker = (Job_Seeker__c)controller.getRecord();
            BPJobSeekerNoSharing.checkBrokeredLiveUserName(jSeeker);
            addMessage(ApexPages.Severity.CONFIRM, 'Username is available.');
        }
        catch (Exception ex)
        {
            addMessage(ex);
        }
    }
}