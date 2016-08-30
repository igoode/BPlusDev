public with sharing class BLAttributesController 
	extends BPPageBase
{
    public BLAttributesController() 
    {
    }

    


    public PageReference goMarketing()
    {
        try
        {
            PageReference pg = PAge.BLEmployerSearch;
            pg.getParameters().put('sessId', LiveSession.ID);
            pg.getParameters().put('chkId', LiveSession.Job_Seeker__c);
            return pg;
        }
        catch(Exception ex)
        {
            return addMessage(ex);
        }
    }
}