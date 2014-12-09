public with sharing class BPEmployerExtension 
	extends BPPageBase
{
    public BPEmployerExtension(ApexPages.StandardController ctrlr)
    {
    	controller = ctrlr;
    }

    private ApexPages.StandardController controller;

    public PageReference newContact()
    {
    	try
    	{
    		throwTestError();
    		PageReference pg = Page.EmployerContact;
    		pg.getParameters().put('empId', controller.getID());
    		return pg.setRedirect(true);
    	}
		catch(Exception ex)
		{
			return addMessage(ex);
		}
    }
}