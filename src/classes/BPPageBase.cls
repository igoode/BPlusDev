public virtual class BPPageBase 
{
    public Boolean testErrorEnabled = false;

    public void throwTestError()
    {
        if(testErrorEnabled)
        {
            Integer i = 0;
            i = 1 / i;
        }
    }
    
    protected PageReference addMessage(Exception ex)
    {
    	ApexPages.addMessages(ex);
        return null;
    }

    protected PageReference addMessage(String s)
    {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, s));
        return null;
    }
    
    protected String getParameter(String parameterName)
    {
    	if(ApexPages.currentPage() == null)
    	{
    		return null;
    	}
        return ApexPages.currentPage().getParameters().get(parameterName);
    }

    protected List<SelectOption> getSelectListFromObjectList(List<sObject> sObjects, String fieldForID, String fieldForLabel)
    {
        return getSelectListFromObjectList(sObjects, fieldForID, fieldForLabel, true);
    }

    protected List<SelectOption> getSelectListFromObjectList(List<sObject> sObjects, String fieldForID, String fieldForLabel, Boolean addNoneOption)
    {
        List<SelectOption> optionList = new List<SelectOption>();
        if(addNoneOption)
        {
            optionList.add(new SelectOption('',  '--None--'));
        }
        for(sObject obj : sObjects)
        {
            String idValue = (String)obj.get(fieldForID);
            String labelValue = (String)obj.get(fieldForLabel);
            optionList.add(new SelectOption(idValue, labelValue));
        }
        return optionList;
    }

    
    
}