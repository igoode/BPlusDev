public with sharing class BPWageSubsidyController 
	extends BPPageBase
{
    public BPWageSubsidyController()
    {
    	for(Business__c b : [SELECT ID, 
    								Name,
    								(SELECT Contact_Person__c,
    										Contact_Email__c,
    										Address__c
    								FROM 	Employer_Contacts__r
    								ORDER BY CreatedDate DESC 
    								LIMIT 1)
    						FROM 	Business__c
    						WHERE 	ID =:getParameter('empId')])
		{
			Employer = b;
			EmployerContact.Business__c = employer.ID;
			if(b.Employer_Contacts__r.size() > 0)
			{
				EmployerContact.Address__c = b.Employer_Contacts__r[0].Address__c;
			}
		}
		for(Job_Seeker__c jsk : [SELECT ID,
										Name,
										JSK_ID__c,
										Account__c 
								FROM 	Job_Seeker__c
								WHERE ID = :getParameter('jskId')])
		{
			JobSeeker = jsk;
			EmployerContact.Job_Seeker__c = jobSeeker.ID;
		}
		String empAddress = getParameter('ea');
		String contactPerson = getParameter('cp');
		String contactEmail = getParameter('ce');
		String wgSubsidy = getParameter('ws');
		String hrs = getParameter('hr');
		String ecMobile = getParameter('ecm');
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
		if(String.isNotBlank(wgSubsidy))
		{
			WageSubsidy = wgSubsidy;
		}
		if(String.isNotBlank(hrs))
		{
			Hours = hrs;
		}
		if(String.isNotBlank(ecMobile))
		{
			ECMobile = ecMobile;
		}
system.debug( getParameter('ecm'));			
system.debug(ECMobile);		
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

    public String WageSubsidy
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

    public PageReference preview()
    {
    	try
    	{
	    	ShowPreview = true;
	    	PageReference pg = Page.BPWageSubsidy;
	    	setParameters(pg);
	    	return pg.setRedirect(true);
	    }
    	catch(Exception ex)
    	{   		
    		return addMessage(ex);
    	}
    }

    public PageReference sendSubsidy()
    {
    	Savepoint sp = Database.setSavepoint();
    	try
    	{
    		Boolean valid = true;
    		valid = isRequiredFieldValid(EmployerContact.Contact_Person__c, 'Employer contact person', valid);
    		valid = isRequiredFieldValid(EmployerContact.Contact_Email__c, 'Employer email', valid);
    		valid = isRequiredFieldValid(WageSubsidy, 'Wage subsidy', valid);
    		valid = isRequiredFieldValid(Hours, 'Hours per week', valid);
    		valid = isRequiredFieldValid(EmployerContact.Contact_Person__c, 'Employer contact person', valid);
    		if(!valid)
    		{
    			ShowPreview = false;
    			return null;
    		}

    		EmployerContact.Result__c = 'Wage Subsidy Sent';
    		EmployerContact.Business__c = Employer.ID;
    		EmployerContact.Job_Seeker__c = JobSeeker.ID;
    		upsert EmployerContact;

    		PageReference pg = Page.BPWageSubsidyPDF;
    		setParameters(pg);
    		Blob pdfContent = pg.getContent();
    		Attachment att = new Attachment();
    		att.ParentId = EmployerContact.ID;
    		att.Body = pdfContent;
    		att.Description = 'Wage subsidy for ' + Employer.Name;
    		att.Name = 'Wage subsidy offer for ' + Employer.Name;
    		insert att;
    		
    		Messaging.EmailFileAttachment fileAttachment = new Messaging.EmailFileAttachment();
    		fileAttachment.setBody(pdfContent);
    		fileAttachment.setContentType('application/pdf');
    		fileAttachment.setInline(false);
    		fileAttachment.setFileName(jobSeeker.Name + '_WageSubsidy.pdf');

    		Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
    		msg.setFileAttachments(new List<Messaging.EmailFileAttachment>{fileAttachment});
    		msg.setToAddresses(new List<String> {EmployerContact.Contact_Email__c});
    		msg.setCcAddresses(new List<String> {CurrentUser.Email});
    		msg.setPlainTextBody(' ');
    		msg.setSubject('Wage Subsidy for ' + JobSeeker.Name);
    		Messaging.sendEmail(new List<Messaging.Email>{msg});

    		addMessage(ApexPages.Severity.INFO, 'Wage subsidy successfully sent.');

    		pg = Page.BPWageSubsidy;
    		setParameters(pg);
    		ShowPreview = false;
    		return pg.setRedirect(true);
    	}
    	catch(Exception ex)
    	{
    		return addMessage(ex, sp);
    	}
    }

    private void setParameters(PageReference pg)
    {
system.debug(Employer);    	
system.debug(JobSeeker);   
system.debug(EmployerContact); 
    	pg.getParameters().put('empId', Employer.ID);
		pg.getParameters().put('jskId', JobSeeker.ID);
		pg.getParameters().put('ea', EncodingUtil.urlEncode(EmployerContact.Address__c, 'UTF-8'));
		pg.getParameters().put('cp', EmployerContact.Contact_Person__c);
		pg.getParameters().put('ce', EmployerContact.Contact_Email__c);
		pg.getParameters().put('ws', WageSubsidy);
system.debug(ECMobile);		
		pg.getParameters().put('ecm', ECMobile);
		pg.getParameters().put('hr', Hours);
    }
}