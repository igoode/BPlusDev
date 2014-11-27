public virtual class BPPageBase 
{
    public Boolean testErrorEnabled = false;
    private transient USer tCurrentUser;

    public String IPAddress
    {
        get;
        set;
    }
    
    public void throwTestError()
    {
        if(testErrorEnabled)
        {
            Integer i = 0;
            i = 1 / i;
        }
    }
    
    protected User CurrentUser
    {
        get
        {
            if(tCurrentUser == null)
            {
                tCurrentUser = [SELECT Id, 
                                        Name, 
                                        Username, 
                                        LastName, 
                                        FirstName, 
                                        Title, 
                                        Email, 
                                        Alias, 
                                        IsActive, 
                                        ProfileId, 
                                        UserType, 
                                        ContactId, 
                                        Contact.AccountID,
                                        AccountId
                                FROM    User
                                WHERE   ID = :UserInfo.getUserId()];
            }
            return tCurrentUser;
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

    protected PageReference addMessage(ApexPages.Severity importance, String s)
    {
        ApexPages.addMessage(new ApexPages.Message(importance, s));
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

    protected Boolean isRequiredFieldValid(object val, String fieldName, Boolean wasPreviouslyValid)
    {
        return isRequiredFieldValid(val, fieldName, null, wasPreviouslyValid, true);
    }

    /*protected Boolean isRequiredFieldValid(object val, String fieldName, String msgSuffix, Boolean wasPreviouslyValid)
    {
        return isRequiredFieldValid(val, fieldName, msgSuffix, wasPreviouslyValid, true);
    }

    protected Boolean isRequiredFieldValid(object val, String fieldName, Boolean wasPreviouslyValid, Boolean displayMessage)
    {
        return  isRequiredFieldValid(val, fieldName, null, wasPreviouslyValid, displayMessage);
    }*/

    protected Boolean isRequiredFieldValid(object val, String fieldName, String msgSuffix, Boolean wasPreviouslyValid, Boolean displayMessage)
    {
        if(val == null)
        {
            if(displayMessage)
            {
                getRequiredFieldMessage(fieldName, msgSuffix);
            }
            return false;
        }
        return wasPreviouslyValid ? true : wasPreviouslyValid;
    }
    
    /*protected void getRequiredFieldMessage(String fieldName)
    {
        addMessage(fieldName + ' is required.');
    }*/

    protected void getRequiredFieldMessage(String fieldName, String msgSuffix)
    {
        addMessage(fieldName + ' is required' + (msgSuffix == null ? '.' : msgSuffix + '.'));
    }

}