public class BPFollowupExtension 
	extends BPPageBase
{
    public BPFollowupExtension(ApexPages.StandardController ctrlr)
    {
    	controller = ctrlr;
    }

    private ApexPages.StandardController controller;

    public void saveOverride()
    {
    	try
    	{
			Follow_Up__c fu = (Follow_Up__c)controller.getRecord();
    		if(fu.Actioned__c == null)
    		{
    			fu.Actioned__c = Datetime.now();
    		}
    		update fu;
    	}
        catch(Exception ex)
        {
            addMessage(ex);
        }
    }
}