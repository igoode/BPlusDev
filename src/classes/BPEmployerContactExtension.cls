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
    	String employerID = getParameter('empId');
        String vacancyID = getParameter('vacId');
        employerContact = (Employer_Contact__c)ctrlr.getRecord();
    	if(String.isNotBlank(employerID))
    	{    		
    		Employer = [SELECT ID,
    							Name,
    							Last_Contacted__c,
    							Last_Contacted_By__c,
                                Sensis_ID__c
    					FROM 	Business__c
    					WHERE 	ID = :employerID];
			employerContact.User__c = UserInfo.getUserId();
			employerContact.Contacted_On__c = Date.today();
    	}
        else if(String.isNotBlank(vacancyID))
        {
            Vacancy = [SELECT   ID, 
                                Employer_Contact__c,
                                Employer_Contact__r.Business__c,
                                Employer_Contact__r.Business__r.Sensis_ID__c
                        FROM    Follow_Up__c
                        WHERE   ID = :vacancyID];
            if(employerContact.Business__c == null)
            {
            	employerContact.Business__c = Vacancy.Employer_Contact__r.Business__c;
            }
            Employer.Sensis_ID__c = Vacancy.Employer_Contact__r.Business__r.Sensis_ID__c;
        }
        jobSeekerID = employerContact.Job_Seeker__c;
    }

    private transient  List<Follow_Up__c> tFollowups;

    private Employer_Contact__c employerContact;

    public String ReferralTo
    {
        get;
        set;
    }

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

    public Follow_Up__c EmployerFollowUp 
    {
        get
        {
            if(EmployerFollowUp == null)
            {
                EmployerFollowUp = new Follow_Up__c(Job_Seeker__c = JobSeeker.ID, 
                                            Assigned_To__c = UserInfo.getUserId(),
                                            Type__c = BPConstants.FollowUp_Type_CallEmployer);
            }
            return EmployerFollowUp;
        }
        set;
    }

    public Follow_Up__c JobseekerFollowUp 
    {
        get
        {
            if(JobseekerFollowUp == null)
            {
                JobseekerFollowUp = new Follow_Up__c(Job_Seeker__c = JobSeeker.ID, 
                                            Assigned_To__c = UserInfo.getUserId(),
                                            Type__c = BPConstants.FollowUp_Type_CallJobseeker);
            }
            return JobseekerFollowUp;
        }
        set;
    }

    public List<Follow_Up__c> Followups
    {
        get
        {
            if(tFollowups == null)
            {
                tFollowups = [SELECT Id, 
                                    Name,                                            
                                    Actioned__c, 
                                    Address_Confirmed__c, 
                                    Action_Taken__c,
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
                                    Comment__c,
									Open_Vacancy__c,
                                    Job_Seeker__r.Name,
                                    Employer_Contact__c,
                                    Employer_Contact__r.Result__c,
                                    Employer__c                     
                            FROM    Follow_Up__c
                            WHERE   Employer_Contact__c = :employerContact.ID
                            ORDER BY Due_Date__c DESC];
            }
            return tFollowups;
        }
    }


    public void getEmployerAddress()
    {
        try
        {
            if(String.isBlank(employerContact.Address__c) || String.isBlank(employerContact.Contact_Number__c))
            {
                SensisSearchController searchCtrl = new SensisSearchController();
                for(SensisResponse.Results result : searchCtrl.doSearchByID(Employer.Sensis_ID__c))
                {
                    employerContact.Address__c = result.Address;
                    employerContact.Contact_Number__c = result.ContactNumber;
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
            validateMobileNumber(MobileNumber);
            BPSMSUtilities.sendMeetingSMS(employerContact, MobileNumber, CurrentUser.Account_Name__c);
            addMessage(ApexPages.Severity.INFO, 'SMS sent.');
        }
        catch(Exception ex)
        {
            addMessage(ex);
        }
    }

    public PageReference saveOverride()
    {
        Savepoint sp = Database.setSavepoint();
        try
        {
			if(CurrentUser.Marketing_Only__c)
			{
				for(Job_Seeker__c js : [SELECT	ID
										FROM	Job_Seeker__c
										WHERE	Marketing_Only__c = true AND 
												Assigned_To__c = :CurrentUser.ID])
				{
					employerContact.Job_Seeker__c = js.ID;
				}
			}
			Boolean newRecord = employerContact.ID == null;
            Boolean valid = isRequiredFieldValid(employerContact.Job_Seeker__c, 'Job Seeker', true);
            valid = isRequiredFieldValid(employerContact.Result__c, 'Result', valid);
            valid = isRequiredFieldValid(employerContact.Contacted_On__c, 'Contacted On', valid);
            if(employerContact.Result__c == BPConstants.EmployerContact_Result_ResumeDropOff || employerContact.Result__c == BPConstants.EmployerContact_Result_Interview)
            {
                valid = isRequiredFieldValid(employerContact.Interview_Date__c, 'Interview/Meeting date', valid);
                valid = isRequiredFieldValid(employerContact.Interview_Time__c, 'Interview/Meeting time', valid);
            }
            if(!valid)
            {
                return null;
            }
            if(employerContact.Business__c == null)
            {
                employerContact.Business__c = Employer.ID;
            }
            if(Vacancy.ID != null)
            {
                employerContact.Vacancy_Contact__c = Vacancy.Employer_Contact__c;
            }
            if(employerContact.Contacted_On__c == null)
            {
                employerContact.Contacted_On__c = Datetime.now();
            }
            if(CurrentUser.Marketing_Only__c &&
                    employerContact.Result__c.endsWith('Signup') &&
                    ReferralTo != null)
            {
                employerContact.Result__c = BPConstants.EmployerContact_Result_Referral;
            }
            upsert employerContact;

            if(CurrentUser.Marketing_Only__c &&
                    employerContact.Result__c == BPConstants.EmployerContact_Result_Referral &&
                    ReferralTo != null) 
            {
                BPEmployerExtension.createReferral(employerContact, ReferralTo);
            }

            if(EmployerFollowUp.Due_Date__c != null)
            {
                if(EmployerFollowUp.Employer_Contact__c == null)
                {
                    EmployerFollowUp.Employer_Contact__c = employerContact.ID;
                }
                upsert EmployerFollowUp;
            }
            if(JobseekerFollowUp.Due_Date__c != null)
            {
                if(JobseekerFollowUp.Employer_Contact__c == null)
                {
                    JobseekerFollowUp.Employer_Contact__c = employerContact.ID;
                }
                upsert JobseekerFollowUp;
            }
			if(newRecord) 
			{
				PageReference pg = Page.EmployerContact; 
				pg.getParameters().put('id', employerContact.ID);
				return pg.setRedirect(true);
			}
			return null;
        }
        catch(Exception ex)
        {
            return addMessage(ex, sp);
        }
    }

    public void getJobSeeker()
    {
        String jsId = getParameter('jsId');
        employerContact.Job_Seeker__c = jsId;
    }
}