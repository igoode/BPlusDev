public with sharing class BPFollowupExtension 
	extends BPPageBase
{
    public BPFollowupExtension()
    {}

    public BPFollowupExtension(ApexPages.StandardController ctrlr)
    {
        if(!Test.isRunningTest())
        {
            ctrlr.addFields(new String[]{'Type__c', 
                                        'Vacancy_Closed__c', 
                                        'Employer_Contact__r.Result__c', 
                                        'Open_Vacancy__c', 
                                        'Employer_Contact__c', 
                                        'Followup_Employer_Contact__c', 
                                        'Interview_Date__c', 
                                        'Interview_Time__c', 
                                        'Job_Seeker__c', 
                                        'Job_Seeker__r.Name', 
                                        'Assigned_To__c',
                                        'Assigned_To__r.Name'});
        }
    	controller = ctrlr;
        followUp = (Follow_Up__c)controller.getRecord();
        if(followUp.RecordTypeID == null)
        {
            followUp.RecordTypeID = BPConstants.FollowUp_RecordType_Followup_ID;
        }
        if(getParameter('jskId') != null)
        {
            followUp.Job_Seeker__c = getParameter('jskId');
        }
        if(getParameter('ecId') != null)
        {
            followUp.Employer_Contact__c = getParameter('ecId');
        }
        for(Business__c b : [SELECT ID, 
                                    Name 
                            FROM    Business__c 
                            WHERE   ID = :getParameter('empId')])
        {
            EmployerName = b.Name;
        }
        
        jobSeekerID = followUp.Job_Seeker__c;
        originalFollowupType = followUp.Type__c;
        originalAssignedTo = followUp.Assigned_To__c;
    }

    private ApexPages.StandardController controller;
    private Follow_Up__c followUp;
    private String originalFollowupType;
    private ID originalAssignedTo;

    private transient List<Follow_Up__c> tRelatedFollowUps;
    private transient List<Employer_Contact__c> tRelatedContacts;
    private transient List<SelectOption> tAssignedToList;

    public String JobSeekerSearch
    {
        get;
        set;
    }

    public List<SelectOption> AssignedToList
    {
        get
        {
            if(tAssignedToList == null)
            {
                tAssignedToList = getSelectListFromObjectList(SiteUsers, false);
                tAssignedToList.add(0, new SelectOption('', 'Open To All'));
            }
            return tAssignedToList;
        }
    }

	public List<SelectOption> MarketingPlacedOptions
    {
        get
        {
            if(MarketingPlacedOptions == null)
            {
                MarketingPlacedOptions = new List<SelectOption>();
				MarketingPlacedOptions.add(new SelectOption('',  '--None--'));
                MarketingPlacedOptions.addAll(ExtraResultOptions);
            }
            return MarketingPlacedOptions;
        }
		private set;
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

    public String EmployerName
    {
        get;
        private set;
    }

    public String JobTitle
    {
        get;
        set;
    }

    public String Comment
    {
        get;
        set;
    }
   
    public List<Follow_Up__c> RelatedFollowUps
    {
        get
        {
            if(tRelatedFollowUps == null)
            {
                tRelatedFollowUps = [SELECT Id, 
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
                                            Result__c, 
                                            No_Further_Action_Required__c,
                                            Employer__c,
                                            Job_Seeker__r.Name,
                                            Assigned_To__c,
                                            Assigned_To__r.Name,
                                            Employer_Contact_Person__c, 
                                            Employer_Contact_Position__c, 
                                            Employer_Contact__r.Result__c,
                                            Employer_Contact__r.Business__c,
                                            Employer_Contact__r.Business__r.Location__c,
                                            Employer_Contact__r.Job_Title__c,
                                            Employer_Contact__r.Comment__c
                                    FROM    Follow_Up__c
                                    WHERE   RecordTypeID = :BPConstants.FollowUp_RecordType_Followup_ID AND
                                            Employer_Contact__c != null AND
                                            (Employer_Contact__c = :followUp.Employer_Contact__c OR 
                                            Employer_Contact__r.Vacancy_Contact__c = :followUp.Employer_Contact__c) AND  
                                            ID != :followUp.ID
                                    ORDER BY Due_Date__c DESC];
            }
            return tRelatedFollowUps;
        }
    }

    public List<Employer_Contact__c> RelatedContacts
    {
        get
        {
            if(tRelatedContacts == null)
            {
                tRelatedContacts = [SELECT Id, 
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
                                    FROM    Employer_Contact__c
                                    WHERE   Vacancy_Contact__c = :followUp.Employer_Contact__c AND 
                                            Vacancy_Contact__c != null
                                    ORDER BY Contacted_On__c DESC NULLS LAST];
            }
            return tRelatedContacts;
        }
    }

    public PageReference redir()
    {
        try
        {
            throwTestError();
            followUp = (Follow_Up__c)controller.getRecord();

            if(followUp.Employer_Contact__r.Result__c == BPConstants.EmployerContact_Result_Vacancy && 
                    followUp.Open_Vacancy__c)
            {
                PageReference pg = Page.BPVacancy;
                pg.getParameters().put('id', followUp.ID);
                return pg.setRedirect(true);
            }
            return null;
        }
        catch(Exception ex)
        {
            return addMessage(ex);
        }
    }

    public void actioned()
    {
        try
        {
            throwTestError();
            followUp = (Follow_Up__c)controller.getRecord();
            followUp.Actioned__c = Datetime.now();
            update followup;
        }
        catch(Exception ex)
        {
            addMessage(ex);
        }
    }

    public PageReference saveVacancy()
    {
        Savepoint sp = Database.setSavepoint();
        try
        {
            throwTestError(); 
            if(followUp.ID == null)
            {
                if(String.isBlank(JobTitle))
                {
                    addMessage('Job Title is required.');
                    return null;
                }
                Employer_Contact__c ec = new Employer_Contact__c();
                ec.Business__c = getParameter('empId');
                ec.Result__c = BPConstants.EmployerContact_Result_Vacancy;
                ec.Job_Title__c = JobTitle;
                ec.Comment__c = Comment;
                insert ec;
                followup.Employer_Contact__c = ec.ID;
                insert followup;

                if(followup.Open_Vacancy__c)
                {
                    EmailTemplate template = [SELECT ID 
                                        FROM    EmailTemplate 
                                        WHERE   DeveloperName = 'Open_Vacancy'];

                    List<Messaging.SingleEmailMessage> msgs = new List<Messaging.SingleEmailMessage>();                                    
                    for(User u : SiteUsers)
                    {               
                        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                        msg.setWhatId(ec.ID);
                        msg.setTargetObjectId(u.ID);
                        msg.setSaveAsActivity(false);
                        msg.setTemplateId(template.Id);
                        msgs.add(msg);
                    }            
                    Messaging.sendEmail(msgs);
                }

                PageReference pg = Page.BPVacancy;
                pg.getParameters().put('id',followup.ID);
                return pg.setRedirect(true);
            }
            else
            {
                update followUp; 
            }

            if(originalAssignedTo != followUp.Assigned_To__c)
            { 
                Follow_Up__c relatedFollowup = new Follow_Up__c(RecordTypeID = BPConstants.FollowUp_RecordType_Followup_ID);
                relatedFollowup.Employer_Contact__c = followUp.Employer_Contact__c;
                relatedFollowup.Assigned_To__c = followUp.Assigned_To__c;
                relatedFollowup.Type__c = BPConstants.FollowUp_Type_VacancyAssigned;
                insert relatedFollowup;
            }
            tRelatedFollowUps = null;
            tRelatedContacts = null;
            return null;
        }
        catch(Exception ex)
        {
            return addMessage(ex, sp);
        }
    }

    public PageReference saveOverride()
    {
        Savepoint sp = Database.setSavepoint();
    	try
    	{
            throwTestError();
            Boolean newRecord = jobSeeker.ID == null;
            if(String.isNotBlank(followUp.Result__c) && followUp.Actioned__c == null)
            {
                followUp.Actioned__c = DateTime.now();
            }
    		upsert followUp;

            if(newRecord)
            {
                return null;     
            }
            PageReference pg = Page.FollowUp; 
            pg.getParameters().put('id', followup.ID);
            return pg.setRedirect(true);  
    	}
        catch(Exception ex)
        {
            return addMessage(ex, sp);
        }
    }

    public void sendEmployerDetails()
    {
        try
        {
            throwTestError();
            Follow_Up__c fu = (Follow_Up__c)controller.getRecord();
            Employer_Contact__c ec = getEmployerContact(fu.Followup_Employer_Contact__c == null ? fu.Employer_Contact__c : fu.Followup_Employer_Contact__c);
            Job_Seeker__c jobSeeker = new Job_Seeker__c(ID = fu.Job_Seeker__c);     
            Date interviewDate = fu.Interview_Date__c == null ? ec.Interview_Date__c : fu.Interview_Date__c;
            String interviewTime = fu.Interview_Time__c == null ? ec.Interview_Time__c : fu.Interview_Time__c;
            String message;
            if(ec.Result__c == BPConstants.EmployerContact_Result_Interview)
            {
                message = 'Hi ' + fu.Job_Seeker__r.Name + ', ' + fu.Assigned_To__r.Name +               
                        ' has arranged for you to meet an employer at ' + ec.Address__c +
                        ' on ' + interviewDate.format() + 
                        ' at ' + interviewTime + 
                        '. Please contact the office if you have any queries';
            }
            else
            {
                 message = 'Hi ' + fu.Job_Seeker__r.Name + ', ' + fu.Assigned_To__r.Name +               
                        ' has arranged for you to drop your resume at ' + ec.Address__c +
                        ' on ' + interviewDate.format() + 
                        ' at ' + interviewTime + 
                        '. Please contact the office if you have any queries';
            }   
            validateMobileNumber(MobileNumber);  
            Communication__c notification = sendSMS(jobSeeker, message, ec.Result__c, MobileNumber);
            notification.RecordTypeId = CommunicationRecordTypesByName.get(BPConstants.Communication_RecordType_SMSNotification).getRecordTypeID();
            insert notification;                     
            addMessage(ApexPages.Severity.INFO, 'SMS sent.');
        }
        catch(Exception ex)
        {
            addMessage(ex);
        }
    }

    public void closeVacancy()
    {
        try
        {
            throwTestError();
            setClosedDate(Date.today());
        }
        catch(Exception ex)
        {
            addMessage(ex);
        }
    }

    public void openVacancy()
    {
        try
        {
            throwTestError();
            setClosedDate(null);
        }
        catch(Exception ex)
        {
            addMessage(ex);
        }
    }

    public static Communication__c sendSMS(Job_Seeker__c jobSeeker, String message, String type, String mobNumber)
    {
        String smsReference = null;
        Communication__c notification = new Communication__c(Job_Seeker__c = jobSeeker.ID,
                                                    Number__c = mobNumber,
                                                    Message__c = message,
                                                    Type__c = type);
        notification.RecordTypeId = (new BPPageBase()).CommunicationRecordTypesByName.get(BPConstants.Communication_RecordType_SMSNotification).getRecordTypeID();
        smsReference = BPSMSUtilities.sendSMS(message, mobNumber, null); 
        if(smsReference != null)
        {
            notification.Sent__c = Datetime.now();
            notification.Gateway_Reference__c = smsReference;
            return notification;
        }
        return null;
    }

    private void setClosedDate(Date dt)
    {
        Follow_Up__c fu = (Follow_Up__c)controller.getRecord();
        fu.Vacancy_Closed__c = dt;
        update fu;
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
                        Call_Back_Time__c,
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