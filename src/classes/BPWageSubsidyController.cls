public with sharing virtual class BPWageSubsidyController 
    extends BPPageBase
{
    public BPWageSubsidyController(ApexPages.StandardController ctrlr)
    {

    }
    
    public BPWageSubsidyController()
    {
        for(Employer_Contact__c ec : [SELECT ID,
                                            User__c
                                    FROM    Employer_Contact__c 
                                    WHERE   ID = :getParameter('ecId')])
        {
            EmployerContact = ec;
        }

        for(Business__c b : [SELECT ID, 
                                    Name,
                                    (SELECT Contact_Person__c,
                                            Contact_Email__c,
                                            Address__c
                                    FROM    Employer_Contacts__r
                                    ORDER BY CreatedDate DESC 
                                    LIMIT 1)
                            FROM    Business__c
                            WHERE   ID =:getParameter('empId')])
        {
            Employer = b;
            //EmployerContact.Business__c = employer.ID;
            if(b.Employer_Contacts__r.size() > 0)
            {
                EmployerContact.Address__c = b.Employer_Contacts__r[0].Address__c;
            }
        }

        for(Job_Seeker__c jsk : [SELECT ID,
                                        Name,
                                        JSK_ID__c,
                                        Account__c 
                                FROM    Job_Seeker__c
                                WHERE ID = :getParameter('jskId')])
        {
            JobSeeker = jsk;
            EmployerContact.Job_Seeker__c = jobSeeker.ID;
        }
        String empAddress = getParameter('ea');
        String contactPerson = getParameter('cp');
        String contactEmail = getParameter('ce');
        String wgSubsidy13 = getParameter('ws13');
        String wgSubsidy26 = getParameter('ws26');
        String hrs = getParameter('hr');
        String ecMobile = getParameter('ecp');
        if(String.isNotBlank(empAddress))
        {
            EmployerContact.Address__c = EncodingUtil.urlDecode(empAddress, 'UTF-8');
        }
        if(String.isNotBlank(contactPerson))
        {
            EmployerContact.Contact_Person__c = contactPerson;
        }
        if(String.isNotBlank(contactEmail))
        {
            EmployerContact.Contact_Email__c = contactEmail;
        }
        if(String.isNotBlank(wgSubsidy13))
        {
            WageSubsidy13Week = wgSubsidy13;
        }
        if(String.isNotBlank(wgSubsidy26))
        {
            WageSubsidy26Week = wgSubsidy26;
        }
        if(String.isNotBlank(hrs))
        {
            Hours = hrs;
        }
        if(String.isNotBlank(ecMobile))
        {
            ECMobile = ecMobile;
        }    
        ShowPreview = String.isNotBlank(EmployerContact.Address__c) && String.isNotBlank(EmployerContact.Contact_Person__c);
    }

    public Business__c Employer
    {
        get;
        set;
    }

    public Job_Seeker__c JobSeeker
    {
        get;
        set;
    }

    public Blob Attachment
    {
        get;
        set;
    }

    public String FileName
    {
        get;
        set;
    }

    public Employer_Contact__c EmployerContact 
    {
        get
        {
            if(EmployerContact == null)
            {
                EmployerContact = new Employer_Contact__c();
            }
            return EmployerContact;
        }
        set;
    }

    public Account UserAccount
    {
        get
        {
            if(UserAccount == null)
            {

                UserAccount = BPAccount.getAccount(CurrentUser.AccountId == null ? jobSeeker.Account__c : CurrentUser.AccountId);
            }
            return UserAccount;
        }
        private set;
    }

    public String Today
    {
        get
        {
            return Date.today().format();
        }
    }

    public Boolean ShowPreview
    {
        get;
        set;
    }

    public String WageSubsidy13Week
    {
        get;
        set;
    }

    public String WageSubsidy26Week
    {
        get;
        set;
    }

    public String Hours
    {
        get;
        set;
    }

    public String ECMobile
    {
        get;
        set;
    }

    /*public PageReference preview()
    {
        try
        {
            throwTestError();
            Boolean valid = true;
            valid = isRequiredFieldValid(EmployerContact.Contact_Person__c, 'Employer contact person', valid);
            valid = isRequiredFieldValid(EmployerContact.Contact_Email__c, 'Employer email', valid);
            valid = isRequiredFieldValid(WageSubsidy13Week, '13 week wage subsidy', valid);
            valid = isRequiredFieldValid(WageSubsidy26Week, '26 week wage subsidy', valid);
            valid = isRequiredFieldValid(Hours, 'Hours per week', valid);
            valid = isRequiredFieldValid(EmployerContact.Contact_Person__c, 'Employer contact person', valid);
            valid = isRequiredFieldValid(ECMobile, 'My Contact Number', valid);
            if(!valid)
            {
                ShowPreview = false;
                return null;
            }
            ShowPreview = true;
            PageReference pg = Page.BPWageSubsidy;
            pg.getParameters().put('id', EmployerContact.ID);
            return pg.setRedirect(true);
        }
        catch(Exception ex)
        {           
            return addMessage(ex);
        }
    }*/

    public PageReference sendSubsidy()
    {
        try
        {
            throwTestError();
            Boolean valid = true;
            valid = isRequiredFieldValid(EmployerContact.Contact_Person__c, 'Employer contact person', valid);
            valid = isRequiredFieldValid(EmployerContact.Contact_Email__c, 'Employer email', valid);
            valid = isRequiredFieldValid(WageSubsidy13Week, '13 week wage subsidy', valid);
            valid = isRequiredFieldValid(WageSubsidy26Week, '26 week wage subsidy', valid);
            valid = isRequiredFieldValid(Hours, 'Hours per week', valid);
            valid = isRequiredFieldValid(EmployerContact.Contact_Person__c, 'Employer contact person', valid);
            valid = isRequiredFieldValid(ECMobile, 'My Contact Number', valid);
            if(!valid)
            {
                return null;
            }
            generateSubsidyAndSend();
            PageReference pg = Page.BPWageSubsidySent;
            setParameters(pg);
            return pg.setRedirect(true);
        }
        catch(Exception ex)
        {
            return addMessage(ex);
        }
    }

    public void generateSubsidyAndSend()
    {
        
        throwTestError();

        PageReference pg = Page.BPWageSubsidyPDF;
        setParameters(pg);
        Blob pdfContent = Test.isRunningTest() ? Blob.valueOf('test') : pg.getContentAsPDF();

        Savepoint sp = Database.setSavepoint();
        try
        {
            Follow_Up__c followup = new Follow_Up__c();
            followup.Employer_Contact__c = EmployerContact.ID;
            followup.Due_Date__c = Date.today().addDays(1);
            followup.Type__c =  BPConstants.FollowUp_Type_WageSubsidySent;
            followup.Assigned_To__c = EmployerContact.User__c;
            insert followup;

            Communication__c wgSub = new Communication__c();
            wgSub.RecordTypeId = CommunicationRecordTypesByName.get(BPConstants.Communication_RecordType_WageSubsidy).getRecordTypeId();
            wgSub.Employer__c = Employer.ID;
            wgSub.Job_Seeker__c = JobSeeker.ID;
            wgSub.EC__c = UserInfo.getUserId();
            insert wgSub;

            Attachment att = new Attachment();
            att.ParentId = wgSub.ID;
            att.Body = pdfContent;
            att.Description = 'Wage subsidy for ' + Employer.Name;
            att.Name = 'Wage subsidy offer for ' + Employer.Name;
            att.ContentType = 'application/pdf';
            insert att;
            
            List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
            Messaging.EmailFileAttachment fileAttachment = new Messaging.EmailFileAttachment();
            fileAttachment.setBody(pdfContent);
            fileAttachment.setContentType('application/pdf');
            fileAttachment.setInline(false);
            fileAttachment.setFileName(jobSeeker.Name + '_WageSubsidy.pdf');
            attachments.add(fileAttachment);
            
            if(Attachment != null)
            {
                fileAttachment = new Messaging.EmailFileAttachment();
                fileAttachment.setBody(Attachment);
                fileAttachment.setInline(false);
                fileAttachment.setFileName(FileName);
                attachments.add(fileAttachment);
            }

            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
            msg.setFileAttachments(attachments);
            msg.setToAddresses(new List<String> {EmployerContact.Contact_Email__c});
            msg.setTargetObjectId(CurrentUser.ID);
            msg.setSaveAsActivity(false);
            msg.setPlainTextBody(' ');
            msg.setSubject('Wage Subsidy for ' + JobSeeker.Name);
            Messaging.sendEmail(new List<Messaging.Email>{msg});

            addMessage(ApexPages.Severity.INFO, 'Wage subsidy successfully sent.');
        }
        catch(Exception ex)
        {
            addMessage(ex, sp);
        }
    }

    private void setParameters(PageReference pg)
    {
        pg.getParameters().put('empId', Employer.ID);
        pg.getParameters().put('jskId', JobSeeker.ID);
        pg.getParameters().put('ecId', EmployerContact.ID);
        pg.getParameters().put('ea', EncodingUtil.urlEncode(EmployerContact.Address__c, 'UTF-8'));
        pg.getParameters().put('cp', EmployerContact.Contact_Person__c);
        pg.getParameters().put('ce', EmployerContact.Contact_Email__c);
        pg.getParameters().put('ws13', WageSubsidy13Week);
        pg.getParameters().put('ws26', WageSubsidy26Week);     
        pg.getParameters().put('ecp', ECMobile);
        pg.getParameters().put('hr', Hours);
    }
}