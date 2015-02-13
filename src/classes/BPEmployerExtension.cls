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
                                        FROM    Employer_Contact__c
                                        WHERE   Business__c = :controller.getId()];
                }
                return EmployerContacts;
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