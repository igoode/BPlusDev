public with sharing class BLLoginController 
	extends BPPageBase
{
    public BLLoginController() 
    {

    }

    public String Username
    {
    	get;
    	set;
    }

    public String Passphrase
    {
    	get;
    	set;
    }

    public String PhraseQuestion
    {
    	get;
    	set;
    }

    public void getPhrase()
    {

    	Job_Seeker__c js = getJobseeker();
    	PhraseQuestion = js.BrokeredLive_Phrase_Prompt__c;
    	if(String.isBlank(js.BrokeredLive_Phrase__c))
    	{
    		addMessage('Login not found.');
    	}
    }

    public PageReference login()
    {
        try
        {
        	Job_Seeker__c js = getJobseeker();
        	if(Passphrase == js.BrokeredLive_Phrase__c)
        	{
        		Live_Session__c ls = new Live_Session__c();
        		ls.Job_Seeker__c = js.ID;
        		ls.X1_Marketable_Attribute__c = js.X1_Marketable_Attribute__c;
        		ls.X2_Marketable_Attribute__c = js.X2_Marketable_Attribute__c;
        		ls.X3_Marketable_Attribute__c = js.X3_Marketable_Attribute__c;
        		insert ls;

        		PageReference pg = Page.BLAttributes;
        		pg.getParameters().put('sessId', ls.ID);
        		pg.getParameters().put('chkId', ls.Job_Seeker__c);
        		return pg;
        	}
        	return null;
        }
        catch(Exception ex)
        {
            return addMessage(ex);
        }
    }

    private Job_Seeker__c getJobseeker()
    {
        if(String.isNotBlank(Username))
        {
        	for(Job_Seeker__c js :[SELECT 	ID,
        									X1_Marketable_Attribute__c,
        									X2_Marketable_Attribute__c,
        									X3_Marketable_Attribute__c,
        									BrokeredLive_Phrase__c,
        									BrokeredLive_Phrase_Prompt__c
        							FROM 	Job_Seeker__c
        							WHERE 	BrokeredLive__c = true AND
                                            BrokeredLive_Username__c = :Username AND
											Account__r.BrokeredLive__c = true])
        	{
        		return js;
        	}
        }
    	return new Job_Seeker__c();
    }
}