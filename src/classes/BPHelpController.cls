public with sharing class BPHelpController
	extends BPPageBase 
{
    public BPHelpController()
    {}

    private transient List<Help_Links__c> tHelpLinks;

    public String Question
    {
    	get;
    	set;
    }

	public List<Help_Links__c> HelpLinks
    {
        get
        {
            if(tHelpLinks == null)
            {
                tHelpLinks = [SELECT ID,
                                    Name,
                                    Description__c,
                                    Link__c,
                                    Youtube_ID__c,
                                    Detailed_Description__c
                            FROM    Help_Links__c
                            WHERE   Active__c = true AND
                                    Marketing_only__c = :CurrentUser.Marketing_Only__c
                             ORDER BY Order_By__c];

            }
            return tHelpLinks;
        }
    }

    public void sendEmail()
    {
    	try
    	{
            if(String.isBlank(Question))
            {
                addMessage('Please provide a description of your problem.');
                return;
            }
    		String[] addresses = new String[]{'bpsupport@gtmgroup.com.au'}; //{'support@brokeredplus.com.au'};
    		Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();    		
    		msg.setToAddresses(addresses);
    		msg.setSubject('BrokeredPlus support case.');
    		String message = 'User: ' + CurrentUser.Name + '\n' + 
    						'Site: ' + CurrentUser.Contact.Account.Name + '\n' + 
    						'Query: ' + Question;
    		msg.setPlainTextBody(message);				
    		Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{msg});
	  		addMessage(ApexPages.Severity.INFO, 'Your BrokeredPlus query has been sent, you will be contacted shortly.');
    	}
        catch(Exception ex)
        {
            addMessage(ex);
        }
    }
}