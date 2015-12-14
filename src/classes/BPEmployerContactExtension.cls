public with sharing class BPEmployerContactExtension 
    extends BPPageBase
{
    public BPEmployerContactExtension(Object o)
    {
    }

    public BPEmployerContactExtension(ApexPages.StandardController ctrlr)
    {
        if(!Test.isRunningTest())
        {
            ctrlr.addFields(new String[]{'Job_Seeker__c', 'Business__r.Name'});
        }
    	controller = ctrlr;
    	String employerID = getParameter('empId');
        String vacancyID = getParameter('vacId');
        Employer_Contact__c ec = (Employer_Contact__c)ctrlr.getRecord();
    	if(String.isNotBlank(employerID))
    	{    		
    		Employer = [SELECT ID,
    							Name,
    							Last_Contacted__c,
    							Last_Contacted_By__c,
                                Sensis_ID__c
    					FROM 	Business__c
    					WHERE 	ID = :employerID];
			//ec.Business__c = Employer.ID;
			ec.User__c = UserInfo.getUserId();
			ec.Contacted_On__c = Date.today();
    	}
        else if(String.isNotBlank(vacancyID))
        {
            Vacancy = [SELECT   ID, 
                                Employer_Contact__c,
                                Employer_Contact__r.Business__c,
                                Employer_Contact__r.Business__r.Sensis_ID__c
                        FROM    Follow_Up__c
                        WHERE   ID = :vacancyID];
            ec.Business__c = Vacancy.Employer_Contact__r.Business__c;
            Employer.Sensis_ID__c = Vacancy.Employer_Contact__r.Business__r.Sensis_ID__c;
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

    public Follow_Up__c Vacancy 
    {
        get
        {
            if(Vacancy == null)
            {
                Vacancy = new Follow_Up__c();
            }
            return Vacancy;
        }
        set;
    }

    public void getEmployerAddress()
    {
        try
        {
            Employer_Contact__c ec = (Employer_Contact__c)controller.getRecord(); 
            if(String.isBlank(ec.Address__c) || String.isBlank(ec.Contact_Number__c))
            {
                SensisSearchController searchCtrl = new SensisSearchController();
                for(SensisResponse.Results result : searchCtrl.doSearchByID(Employer.Sensis_ID__c))
                {
                    ec.Address__c = result.Address;
                    ec.Contact_Number__c = result.ContactNumber;
                }
            }
        }
        catch(Exception ex)
        {
            addMessage(ex);
        }
    }

    public void smsDetails()
    {
        try
        {
            Employer_Contact__c ec =  (Employer_Contact__c)controller.getRecord(); 
            validateMobileNumber(MobileNumber);
            BPSMSUtilities.sendMeetingSMS(ec, MobileNumber, CurrentUser.Account_Name__c);
            addMessage(ApexPages.Severity.INFO, 'SMS sent.');
        }
        catch(Exception ex)
        {
            addMessage(ex);
        }
    }

    public void saveOverride()
    {
        try
        {
            Employer_Contact__c ec =  (Employer_Contact__c)controller.getRecord(); 
            Boolean valid = isRequiredFieldValid(ec.Job_Seeker__c, 'Job Seeker', true);
            valid = isRequiredFieldValid(ec.Result__c, 'Result', valid);
            if(ec.Result__c == BPConstants.EmployerContact_Result_ResumeDropOff || ec.Result__c == BPConstants.EmployerContact_Result_Interview)
            {
                valid = isRequiredFieldValid(ec.Interview_Date__c, 'Interview/Meeting date', valid);
                valid = isRequiredFieldValid(ec.Interview_Time__c, 'Interview/Meeting time', valid);
            }
            if(!valid)
            {
                return;
            }
            if(ec.Business__c == null)
            {
                ec.Business__c = Employer.ID;
            }
            if(Vacancy.ID != null)
            {
                ec.Vacancy_Contact__c = Vacancy.Employer_Contact__c;
            }
            ec.Contacted_On__c = Datetime.now();
            ec.User__c = UserInfo.getUserId();         
            controller.save();
        }
        catch(Exception ex)
        {
            addMessage(ex);
        }
    }

    public void getJobSeeker()
    {
        String jsId = getParameter('jsId');
        Employer_Contact__c ec =  (Employer_Contact__c)controller.getRecord();  
        ec.Job_Seeker__c = jsId;
    }
}