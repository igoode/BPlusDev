public with sharing class BPEmployerExtension 
	extends BPPageBase
{
    public BPEmployerExtension(ApexPages.StandardController ctrlr)
    {
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
                                                Category__c, 
                                                Contact_Email__c, 
                                                Contact_Number__c, 
                                                Contact_Person__c, 
                                                Contact_Position__c, 
                                                Contacted_On__c, 
                                                Hours__c, 
                                                Comment__c,
                                                Interview_Date__c, 
                                                Interview_Time__c, 
                                                Job_Details__c, 
                                                Job_Title__c, 
                                                Result__c, 
                                                Sensis_ID__c, 
                                                User__c,
                                                User__r.Name,
                                                Job_Seeker__c,
                                                Job_Seeker__r.Name,
                                                Business__c, 
                                                Business__r.Name
                                        FROM    Employer_Contact__c
                                        WHERE   Business__c = :controller.getId() AND 
                                                Live_Session__c = null ];
                }
                return EmployerContacts;
        }
        private set;
    }

    public List<Follow_Up__c> Followups 
    {
        get
        {
                if(Followups == null)
                {
                    Followups = [SELECT Id, 
                                        Name,
                                        Employer_Contact__c, 
                                        Action_Taken__c,
                                        Actioned__c, 
                                        Address_Confirmed__c, 
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
                                        Comment__c,
                                        Job_Seeker__r.Name,
                                        Employer__c,
                                        Employer_Contact__r.Business__r.Name,
                                        Job_Seeker__r.Assigned_To__r.Name,
                                        Assigned_To__c, 
                                        Assigned_To__r.Name       
                                FROM    Follow_Up__c
                                WHERE   Employer_Contact__r.Business__c = :controller.getId()
                                ORDER BY CreatedDate DESC];
                }
                return Followups;
        }
        private set;
    }

    public List<Communication__c> Subsidies 
    {
        get
        {
                if(Subsidies == null)
                {
                    Subsidies = [SELECT Id, 
                                        CreatedDate,
                                        EC__r.Name,
                                        Job_Seeker__c,
                                        Sent__c,
                                        (SELECT ID 
                                        FROM    Attachments)
                                FROM    Communication__c
                                WHERE   Employer__c = :controller.getId() AND 
                                        RecordType.Name = :BPConstants.Communication_RecordType_WageSubsidy];
                }
                return Subsidies;
        }
        private set;
    }

    public List<Communication__c> Emails 
    {
        get
        {
                if(Emails == null)
                {
                    Emails = [SELECT Id, 
                                        CreatedDate,
                                        EC__r.Name,
                                        Job_Seeker__c,
                                        Message__c,
                                        Sent__c,
                                        Type__c
                                FROM    Communication__c
                                WHERE   Employer__c = :controller.getId() AND 
                                        RecordType.Name = :BPConstants.Communication_RecordType_Email
                                ORDER BY Sent__c DESC];
                }
                return Emails;
        }
        private set;
    }

    public PageReference newContact()
    {
    	try
    	{
    		throwTestError();
    		PageReference pg = Page.EmployerContact;
    		pg.getParameters().put('empId', controller.getID());
    		return pg.setRedirect(true);
    	}
		catch(Exception ex)
		{
			return addMessage(ex);
		}
    }
}