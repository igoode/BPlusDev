public with sharing class BPHelpController
	extends BPPageBase 
{
    public BPHelpController()
    {}

    public String Question
    {
    	get;
    	set;
    }

    public void sendEmail()
    {
    	try
    	{
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