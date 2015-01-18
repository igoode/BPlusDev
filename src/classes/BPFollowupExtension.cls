public with sharing class BPFollowupExtension 
	extends BPPageBase
{
    public BPFollowupExtension(ApexPages.StandardController ctrlr)
    {
        if(!Test.isRunningTest())
        {
            ctrlr.addFields(new String[]{'Employer_Contact__c','Job_Seeker__c','Job_Seeker__r.Mobile__c'});
        }
    	controller = ctrlr;
        followUp = (Follow_Up__c)controller.getRecord();
        jobSeekerID = followUp.Job_Seeker__c;

    }

    private ApexPages.StandardController controller;
    private Follow_Up__c followUp;

    public String JobSeekerSearch
    {
        get;
        set;
    }

    public Job_Seeker__c VacancyJobSeeker
    {
        get
        {
            if(VacancyJobSeeker == null)
            {
                VacancyJobSeeker = new Job_Seeker__c();
            }
            return VacancyJobSeeker;
        }
        set;
    }
    
    public Employer_Contact__c NextContact
    {
        get 
        {
            if(NextContact == null)
            {
                Follow_Up__c fu = (Follow_Up__c)controller.getRecord();
                NextContact = getEmployerContact(fu.Employer_Contact__c);
            }
            return NextContact;
        }
        set;
    }

    public List<Job_Seeker__c> NewJobSeekers
    {
        get
        {
            if(NewJobSeekers == null)
            {
                NewJobSeekers = new List<Job_Seeker__c>();
            }
            return NewJobSeekers;
        }
        set;
    }

    public void searchJS()
    {
        try
        {
            NewJobSeekers = [SELECT ID, 
                                    Name,
                                    JSK_ID__c,
                                    Assigned_To__r.Name
                            FROM    Job_Seeker__c 
                            WHERE   Name LIKE :('%' + JobSeekerSearch + '%')
                            LIMIT 5];
        }
        catch(Exception ex)
        {
            addMessage(ex);
        }
    }

    public void selectJS()
    {
        try
        {
            for(Job_Seeker__c js : [SELECT  ID,
                                            Name
                                    FROM    Job_Seeker__c 
                                    WHERE   ID = :getParameter('newJsId')])
            {
                followUp.Vacancy_Job_Seeker__c = js.ID;
                VacancyJobSeeker = js;
            }
            NewJobSeekers = null;
        }
        catch(Exception ex)
        {
            addMessage(ex);
        }
    }

    public void saveOverride()
    {
        Savepoint sp = Database.setSavepoint();
    	try
    	{
            throwTestError();
            if(!followUp.No_Further_Action_Required__c &&
                    !isRequiredFieldValid(followUp.Action_Taken__c, 'Action Taken', true))
            {
                return;
            }
    		if(followUp.Actioned__c == null)
    		{
    			followUp.Actioned__c = Datetime.now();
    		}
    		update followUp;
            if(!followUp.No_Further_Action_Required__c)
            {               
                if(followUp.Action_Taken__c == BPConstants.FollowUp_ActionTaken_SentAnotherJobseeker)
                {          
                    Employer_Contact__c vacancyContact = new  Employer_Contact__c();
                    vacancyContact.Result__c = BPConstants.EmployerContact_Result_AssignedToVacancy;
                    vacancyContact.User__c = CurrentUser.ID;
                    vacancyContact.Business__c = NextContact.Business__c;
                    vacancyContact.Contacted_On__c = NextContact.Contacted_On__c;
                    vacancyContact.Job_Seeker__c = VacancyJobSeeker.ID;                    
                    insert vacancyContact; 
                    if(followUp.Vacancy_Job_Seeker__c != VacancyJobSeeker.ID)
                    {
                        followUp.Vacancy_Job_Seeker__c = VacancyJobSeeker.ID;
                        update followUp;
                    }                    
                }
                else if(followUp.Action_Taken__c == BPConstants.EmployerContact_Result_ResumeDropOff ||
                    followUp.Action_Taken__c == BPConstants.EmployerContact_Result_Interview ||
                    followUp.Action_Taken__c == BPConstants.EmployerContact_Result_ResumeSent ||
                    followUp.Action_Taken__c == BPConstants.EmployerContact_Result_LeftMessage ||
                    followUp.Action_Taken__c == BPConstants.EmployerContact_Result_NoAnswer)
                {       
                    Employer_Contact__c empContact = getEmployerContact(followUp.Employer_Contact__c);  
                    List<Follow_Up__c> newFollowUps = new List<Follow_Up__c>();
                    String newFuType; 
                    if(followUp.Action_Taken__c == BPConstants.EmployerContact_Result_ResumeDropOff) 
                    {
                        newFollowUps.add(createFollowUp(empContact,  BPConstants.FollowUp_Type_CallJobseekerThenEmployer, NextContact.Interview_Date__c.addDays(1)));
                        newFollowUps.add(createFollowUp(empContact,  BPConstants.FollowUp_Type_CallJobseeker, NextContact.Interview_Date__c.addDays(-1)));
                    }
                    else if(followUp.Action_Taken__c == BPConstants.EmployerContact_Result_ResumeSent)
                    {
                        newFollowUps.add(createFollowUp(empContact,  BPConstants.FollowUp_Type_CallEmployer, Date.today().addDays(1)));
                    }
                    else if(followUp.Action_Taken__c == BPConstants.EmployerContact_Result_LeftMessage  || 
                                followUp.Action_Taken__c == BPConstants.EmployerContact_Result_Callback)
                    {
                        newFollowUps.add(createFollowUp(empContact,  BPConstants.FollowUp_Type_CallEmployer, Date.today().addDays(2)));
                    }
                    else if(followUp.Action_Taken__c == BPConstants.EmployerContact_Result_NoAnswer)
                    {
                        newFollowUps.add(createFollowUp(empContact,  BPConstants.FollowUp_Type_CallEmployer, Date.today().addDays(3)));
                    }
                    insert newFollowUps;
                }
            }
    	}
        catch(Exception ex)
        {
            addMessage(ex, sp);
        }
    }

    public void sendEmployerDetails()
    {
        try
        {
            throwTestError();
            Follow_Up__c fu = (Follow_Up__c)controller.getRecord();
            Employer_Contact__c ec = getEmployerContact(fu.Followup_Employer_Contact__c == null ? fu.Employer_Contact__c : fu.Followup_Employer_Contact__c);
            Job_Seeker__c jobSeeker = new Job_Seeker__c(ID = fu.Job_Seeker__c, Mobile__c = fu.Job_Seeker__r.Mobile__c);
            String message = CurrentUser.Contact.Account.Name + ' has arranged for you to meet an employer at ' + 
                        ec.Address__c +
                        ' on ' + ec.Interview_Date__c.format() + 
                        ' at ' + ec.Interview_Time__c + 
                        '. Please notify us if you are unable to attend.';

            SMS_Notification__c notification = sendSMS(jobSeeker, message, ec.Result__c) ;
            insert notification;                     
            addMessage(ApexPages.Severity.INFO, 'SMS sent.');
        }
        catch(Exception ex)
        {
            addMessage(ex);
        }
    }

    public static SMS_Notification__c sendSMS(Job_Seeker__c jobSeeker, String message, String type)
    {
        String phNumber = BPSMSUtilities.cleanPhoneNumber(jobSeeker.Mobile__c);
        message += ' Do not reply to this message.';
        String smsReference = BPSMSUtilities.sendSMS(message, phNumber, null); 
        SMS_Notification__c notification = new SMS_Notification__c(Job_Seeker__c = jobSeeker.ID,
                                                Number__c = phNumber,
                                                Message__c = message,
                                                Type__c = type);
        if(smsReference != null)
        {
            notification.Sent__c = Datetime.now();
            notification.Gateway_Reference__c = smsReference;
            
        }
        return notification;
    }

    public static Follow_Up__c createFollowUp(Employer_Contact__c ec, String type, Date dueDate)
    {
        Follow_Up__c fu = new Follow_Up__c(Employer_Contact__c = ec.ID);
        fu.Due_Date__c = ec.Call_Back_Date__c == null ? dueDate : ec.Call_Back_Date__c;
        fu.Type__c = type;
        fu.Assigned_To__c = ec.User__c;
        fu.Job_Seeker__c = ec.Job_Seeker__c;
        return fu;
    }


    private Employer_Contact__c getEmployerContact(ID ecID)
    {
        return [SELECT Id, 
                        Name,                                                                                       
                        Category__c, 
                        Contact_Email__c, 
                        Contact_Number__c, 
                        Contact_Person__c, 
                        Contact_Position__c,  
                        Call_Back_Date__c,
                        Contacted_On__c,
                        Hours__c,  
                        Job_Details__c, 
                        Job_Title__c, 
                        Interview_Date__c,
                        Interview_Time__c,
                        Result__c, 
                        User__c,
                        Job_Seeker__c,
                        Address__c,
                        Business__c,
                        Employer_Suburb__c 
                FROM    Employer_Contact__c
                WHERE   ID = :ecID];
    }
}