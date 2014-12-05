public with sharing class BPEmployerContactExtension 
    extends BPPageBase
{
    public BPEmployerContactExtension(ApexPages.StandardController ctrlr)
    {
        if(!Test.isRunningTest())
        {
            ctrlr.addFields(new String[]{'Job_Seeker__c'});
        }
    	controller = ctrlr;
    	String employerID = getParameter('empId');
        Employer_Contact__c ec = (Employer_Contact__c)ctrlr.getRecord();
    	if(String.isNotBlank(employerID))
    	{    		
    		Employer = [SELECT ID,
    							Name,
    							Last_Contacted__c,
    							Last_Contacted_By__c 
    					FROM 	Business__c 
    					WHERE 	ID = :employerID];
			//ec.Business__c = Employer.ID;
			ec.User__c = UserInfo.getUserId();
			ec.Contacted_On__c = Date.today();
    	}
        jobSeekerID = ec.Job_Seeker__c;
    }

    private ApexPages.StandardController controller;

    public Business__c Employer 
    {
    	get
    	{
    		if(Employer == null)
    		{
    			Employer = new Business__c();
    		}
    		return Employer;
    	}
    	set;
    }
}