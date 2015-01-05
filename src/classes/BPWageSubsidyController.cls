public with sharing class BPWageSubsidyController 
	extends BPPageBase
{
    public BPWageSubsidyController()
    {
    	for(Business__c b : [SELECT ID, 
    								Name 
    						FROM 	Business__c
    						WHERE 	ID =:getParameter('empId')])
		{
			employer = b;
		}
		for(Job_Seeker__c jsk : [SELECT ID,
										Name,
										JSK_ID__c 
								FROM 	Job_Seeker__c
								WHERE ID = :getParameter('jskId')])
		{
			jobSeeker = jsk;
		}
    	EmployerContact.Job_Seeker__c = jobSeeker.ID;
    	EmployerContact.Business__c = employer.ID;
    }

    private Business__c employer;
    private Job_Seeker__c jobSeeker;

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

    			UserAccount = BPAccount.getAccount('001O000000YK4sM');//CurrentUser.AccountId);
    		}
    		system.debug(USerAccount.Wage_Subsidy_Logo__c == null);
    		return UserAccount;
    	}
    	private set;
    }

    public String EmailMessage
    {
    	get;
    	set;
    }

    public String Today
    {
    	get
    	{
    		return Date.today().format();
    	}
    }

    public void sendSubsidy()
    {
    	try
    	{
    		EmployerContact.Result__c = 'Wage Subsidy Sent';
    		upsert EmployerContact;
    		Blob pdfContent = Page.BPWageSubsidy.getContentAsPDF();
    		Attachment att = new Attachment();
    		att.ParentId = EmployerContact.ID;
    		att.Body = pdfContent;
    		att.Description = 'Wage Subsidy for ';
    		insert att;

    		Messaging.EmailFileAttachment fileAttachment = new Messaging.EmailFileAttachment();
    		fileAttachment.setBody(pdfContent);
    		fileAttachment.setContentType('application/pdf');
    		fileAttachment.setInline(false);
    		fileAttachment.setFileName(jobSeeker.Name + '_WageSubsidy.pdf');

    		Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
    		msg.setFileAttachments(new List<Messaging.EmailFileAttachment>{fileAttachment});
    		msg.setToAddresses(new List<String> {EmployerContact.Contact_Email__c});
    		msg.setPlainTextBody(EmailMessage);
    		msg.setSubject('Wage Subsidy');
    		Messaging.sendEmail(new List<Messaging.Email>{msg});
    	}
    	catch(Exception ex)
    	{
    		addMessage(ex);
    	}
    }
}