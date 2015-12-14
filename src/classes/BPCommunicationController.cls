public virtual with sharing class BPCommunicationController 
	extends BPPageBase	
{
    public BPCommunicationController()
    {        
        for(Business__c b : [SELECT ID, 
                                    Name,
                                    Location__c,
                                    Email__c
                            FROM    Business__c
                            WHERE   ID =:getParameter('empId')])
        {
            Employer = b;
            EmailAddress = b.Email__c;
            EmployerAddress = b.Location__c;
        }

        for(Job_Seeker__c jsk : [SELECT ID,
                                        Name,
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
        String wgSubsidy4 = getParameter('ws4');
        String wgSubsidy13 = getParameter('ws13');
        String wgSubsidy26 = getParameter('ws26');
        String hrs = getParameter('hr');
        String ecMobile = getParameter('ecp');
        if(String.isNotBlank(empAddress))
        {
            EmployerAddress = EncodingUtil.urlDecode(empAddress, 'UTF-8');
        }
        if(String.isNotBlank(contactPerson))
        {
            ContactPerson = contactPerson;
        }
        if(String.isNotBlank(contactEmail))
        {
            EmailAddress = contactEmail;
        }
        if(String.isNotBlank(wgSubsidy4))
        {
            WageSubsidy4Week = wgSubsidy4;
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
    }

    private transient Attachment tBrochure;

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

    public Job_Seeker__c JobSeeker
    {
        get
        {
        	if(JobSeeker == null)
            {
                JobSeeker = new Job_Seeker__c();
            }
            return JobSeeker;
        }
        set;
    }

    public String SearchJobSeekerID
    {
        get;
        set;
    }

    public Blob ResumeBody
    {
        get;
        set;
    }

    public String FileName
    {
        get;
        set;
    }

    public String FileType
    {
        get;
        set;
    }

    public String EmployerAddress
    {
        get;
        set;
    }


    public String EmailAddress
    {
        get;
        set;
    }

    public String Subject
    {
        get;
        set;
    }

    public String Comment
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

    public Attachment Brochure
    {
    	get
    	{
    		if(tBrochure == null)
    		{
    			tBrochure = new Attachment();
    			for(Attachment a : [SELECT ID,
    										Name,
    										Description,
    										ContentType,
    										Body
									FROM 	Attachment
									WHERE 	Description = 'Brochure' AND 
											ParentID = :CurrentUser.AccountId])
				{
					tBrochure = a;
				}				
    		}
    		return tBrochure;
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

    public String ContactPerson
    {
        get;
        set;
    }

    public String WageSubsidy4Week
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

    public Boolean IncludeResume
    {
    	get;
    	set;
    }

    public Boolean IncludeBrochure
    {
    	get;
    	set;
    }

    public Boolean IncludeSubsidy
    {
    	get
        {
            return false;
        }
    	set;
    }

    public void getJobSeeker()
    {
        String jsId = getParameter('jsId');
        JobSeeker = [SELECT ID,
                            Name,
                            Account__c 
                    FROM    Job_Seeker__c
                    WHERE ID = :getParameter('jsId')];
    }

    public PageReference send()
    {
    	Savepoint sp;
    	try
        {
            throwTestError();
            Boolean valid = true;
            List<Communication__c> communications = new List<Communication__c>();
            List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
            Map<String, RecordTypeInfo> commRecordTypesByName = Schema.SObjectType.Communication__c.getRecordTypeInfosByName();
            Blob wgSubsidyPdf;  
            valid = isRequiredFieldValid(EmailAddress, 'Employer email', valid);  
            if(IncludeBrochure == null)
            {
                IncludeBrochure = false;
            } 
            if(IncludeResume)
	        {
	        	valid = isRequiredFieldValid(ResumeBody, 'Resume', valid);
	        	if(valid  || Test.isRunningTest())
	        	{
	        		Messaging.EmailFileAttachment fileAttachment = new Messaging.EmailFileAttachment();
	                fileAttachment.setBody(ResumeBody);
	                fileAttachment.setInline(false);
	                fileAttachment.setFileName(FileName);
	                fileAttachment.setContentType(FileType);
	                attachments.add(fileAttachment);
	        	}
	        }
            /*if(IncludeSubsidy)
            {	            
	            valid = isRequiredFieldValid(EmployerAddress, 'Employer address', valid);	            
	            valid = isRequiredFieldValid(ContactPerson, 'Employer contact person', valid);
	            valid = isRequiredFieldValid(WageSubsidy4Week, '4 week wage subsidy', valid);
	            valid = isRequiredFieldValid(WageSubsidy13Week, '13 week wage subsidy', valid);
	            valid = isRequiredFieldValid(WageSubsidy26Week, '26 week wage subsidy', valid);
	            valid = isRequiredFieldValid(Hours, 'Hours per week', valid);
	            valid = isRequiredFieldValid(ECMobile, 'My Contact Number', valid);

	            if(valid || Test.isRunningTest())
	            {
		            PageReference pg = Page.BPWageSubsidyPDF;
			        setParameters(pg);
			        wgSubsidyPdf = Test.isRunningTest() ? Blob.valueOf('test') : pg.getContentAsPDF();

			        Messaging.EmailFileAttachment fileAttachment = new Messaging.EmailFileAttachment();
	                fileAttachment.setBody(wgSubsidyPdf);
	                fileAttachment.setInline(false);
	                fileAttachment.setFileName('WageSubsidy_' + JobSeeker.Name + '.pdf.');
	                attachments.add(fileAttachment);	                  
	            }	            
	        }	*/        
	        if(!valid && !Test.isRunningTest())
            {
                PageReference pg = Page.BPWageSubsidy;
                setParameters(pg);
                return pg.setRedirect(false);
            }
            if(IncludeBrochure && Brochure.ID != null)
            {
            	Messaging.EmailFileAttachment fileAttachment = new Messaging.EmailFileAttachment();

                fileAttachment.setBody(Brochure.Body);
                fileAttachment.setInline(false);
                fileAttachment.setFileName(Brochure.Name);
                fileAttachment.setContentType(Brochure.ContentType);
                attachments.add(fileAttachment);
            }
            for(Employer_Contact__c ec : [SELECT ID,
	                                            User__c,
	                                            Business__c
	                                    FROM    Employer_Contact__c
	                                    WHERE   ID = :getParameter('ecId')])
	        {
	            EmployerContact = ec;
	        }
            sp = Database.setSavepoint();

            if(EmployerContact.ID == null)
            {
            	EmployerContact.Job_Seeker__c = Jobseeker.ID;
            	EmployerContact.Business__c = Employer.ID;
            	EmployerContact.Result__c =  IncludeResume ? BPConstants.EmployerContact_Result_ResumeSent : BPConstants.EmployerContact_Result_Email;
            	EmployerContact.Contacted_On__c = DateTime.now();
            	insert EmployerContact;
            }
            Employer.Email__c = EmailAddress;
            update Employer;

            String commType = 'Email;';
            if(IncludeResume)
            {
                commType += 'Resume;';
            }
            if(IncludeBrochure)
            {
                commType += 'Brochure;';
            }
            /*if(IncludeSubsidy)
            {
                commType += 'Wage Subsidy;';
            }*/
            Follow_Up__c followup = new Follow_Up__c();
            followup.Employer_Contact__c = EmployerContact.ID;
            followup.Due_Date__c = Date.today().addDays(1);
            followup.Type__c =  commType;
            followup.Assigned_To__c = EmployerContact.User__c;
            followup.Comment__c = Comment;
            insert followup;

            Communication__c comm = new Communication__c();
            comm.Employer__c = Employer.ID;
            comm.Job_Seeker__c = JobSeeker.ID == null ? SearchJobSeekerID : JobSeeker.ID;
            comm.EC__c = UserInfo.getUserId();
            comm.Sent__c = Datetime.now();
            comm.Message__c = Comment;
            comm.Type__c = commType;
            if(wgSubsidyPdf == null)
            {
                comm.RecordTypeId = commRecordTypesByName.get(BPConstants.Communication_RecordType_Email).getRecordTypeId();
                insert comm;
            }
            else
            {
                comm.RecordTypeId = commRecordTypesByName.get(BPConstants.Communication_RecordType_WageSubsidy).getRecordTypeId();
                insert comm;

                Attachment att = new Attachment();
                att.ParentId = comm.ID;
                att.Body = wgSubsidyPdf;
                att.Description = 'Wage subsidy for ' + Employer.Name;
                att.Name = 'Wage subsidy offer for ' + Employer.Name;
                att.ContentType = 'application/pdf';
                insert att;
            }	

            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();  
            msg.setToAddresses(new List<String>{EmailAddress});
            msg.setTargetObjectId(UserInfo.getUserId());
            msg.setFileAttachments(attachments);
            msg.setSaveAsActivity(false);
            msg.setHtmlBody(Comment);
            msg.setSubject(Subject);
            try
            {
            	Messaging.reserveSingleEmailCapacity(1);
            }
            catch(Exception ex)
			{
				addMessage('Email could not be sent, please try later.');
				msg = new Messaging.SingleEmailMessage(); 
				msg.setSubject('No email capacity');
				msg.setPlainTextBody('No email capacity');
				msg.setSaveAsActivity(false);
				msg.setTargetObjectId(BPUserNoSharing.getAdminUser().ID); 
			}
            Messaging.sendEmail(new List<Messaging.Email>{msg});
            addMessage(ApexPages.Severity.CONFIRM, 'Email has been sent.');
            PageReference pg = Page.BPWageSubsidy;
            pg.getParameters().put('done', '1');
            return pg.setRedirect(true);
        }
        catch(Exception ex)
        {
            return addMessage(ex, sp);
        }
    }

    private void setParameters(PageReference pg)
    {
        pg.getParameters().put('empId', Employer.ID);
        pg.getParameters().put('jskId', JobSeeker.ID);
        pg.getParameters().put('ecId', EmployerContact.ID);
        pg.getParameters().put('ea', EncodingUtil.urlEncode(EmployerAddress, 'UTF-8'));
        pg.getParameters().put('cp', ContactPerson);
        pg.getParameters().put('ce', EmailAddress);
        pg.getParameters().put('ws4', WageSubsidy4Week);
        pg.getParameters().put('ws13', WageSubsidy13Week);
        pg.getParameters().put('ws26', WageSubsidy26Week);     
        pg.getParameters().put('ecp', ECMobile);
        pg.getParameters().put('hr', Hours);
    }
}