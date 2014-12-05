public with sharing class JobSeekerExtension 
    extends BPPageBase
{
    public JobSeekerExtension(ApexPages.StandardController ctrlr) 
    {
        if(!Test.isRunningTest())
        {
            ctrlr.addFields(new String[]{'Account__c','X1_Marketable_Attribute__c','X2_Marketable_Attribute__c','X3_Marketable_Attribute__c'});
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
    										Business__c,
                                            Business__r.Name
									FROM 	Employer_Contact__c
									WHERE 	Job_Seeker__c = :controller.getId()  
									ORDER BY Contacted_On__c DESC NULLS LAST];
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
                                    Due_Date__c, 
                                    Type__c, 
                                    Actioned__c, 
                                    Assigned_To__c, 
                                    Contact_Number__c, 
                                    Email__c, 
                                    Interview_Time__c, 
                                    Interview_Date__c,
                                    Employer__c,
                                    Employer_Contact_Person__c, 
                                    Employer_Contact_Position__c, 
                                    Interview_Result__c, 
                                    Meeting_Result__c 
                            FROM    Follow_Up__c
                            WHERE   Job_Seeker__c = :controller.getId()   
                            ORDER BY Due_Date__c DESC];
            }
            return FollowUps;
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
        try
        {
            throwTestError();
            if(saveOverride() == null)
            {
                return null;
            }
            return commenceMarketing();
        }
        catch(Exception ex)
        {
            return addMessage(ex);
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
            if(String.isBlank(jSeeker.Account__c) && CurrentUser.ContactID != null)
            {
                jSeeker.Account__c = CurrentUser.Contact.AccountID;

            }             
            if(jSeeker.Assigned_To__c == null && jSeeker.Marketing_Ended__c == null)
            {
                jSeeker.Assigned_To__c = CurrentUser.ID;
            }  

            Boolean valid = true; 
            valid = isRequiredFieldValid(jSeeker.Suburb__c, 'Suburb', valid);
            valid = isRequiredFieldValid(jSeeker.State__c, 'State', valid);
            if(!valid)
            {
                return null;
            }
            return controller.save();
        }
        catch(Exception ex)
        {
            return addMessage(ex);
        }
    }
}