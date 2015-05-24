public virtual with sharing class BPPageBase 
{
    public BPPageBase()
    {
        setComaptibility();
    }

    public BPPageBase(ApexPages.StandardController c)
    {
        setComaptibility();
    }

    public Boolean testErrorEnabled = false;
    
    protected ID jobSeekerID;

    private transient User tCurrentUser;
    private transient Job_Seeker__c tJobSeeker;
    private transient List<SelectOption> tConsultants;
    private transient List<User> tSiteUsers;

    public String Interview
    {
        get
        {
            return BPConstants.EmployerContact_Result_Interview;
        }
    }

    public String ResumeDropOff
    {
        get
        {
            return BPConstants.EmployerContact_Result_ResumeDropOff;
        }
    }

    public String CallBack
    {
        get
        {
            return BPConstants.EmployerContact_Result_Callback;
        }
    }
    
    public void throwTestError()
    {
        if(testErrorEnabled)
        {
            Integer i = 0;
            i = 1 / i;
        }
    }
    
    public User CurrentUser
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
                                        Phone,
                                        MobilePhone,
                                        IsActive,                                         
                                        UserType, 
                                        ProfileId,
                                        Profile.Name,
                                        ContactId, 
                                        Contact.AccountID,
                                        AccountId,
                                        Contact.Account.Name,
                                        Account_Name__c
                                FROM    User
                                WHERE   ID = :UserInfo.getUserId()];
            }
            return tCurrentUser;
        }
    }

    public Job_Seeker__c JobSeeker
    {
        get 
        {       
            if(tJobSeeker == null)
            {
                tJobSeeker = new Job_Seeker__c();
                for(Job_Seeker__c js : [SELECT Id, 
                                                Name, 
                                                Account__c, 
                                                Address_Location__c, 
                                                Assigned_To__c, 
                                                Email__c, 
                                                JSK_ID__c,  
                                                Marketing_Ended__c, 
                                                Marketing_Outcome__c, 
                                                Marketing_Started__c, Mobile__c, 
                                                Professional_and_Specialist_Role__c, 
                                                Qualifications__c, 
                                                Site_and_JSK_ID__c, 
                                                State__c, 
                                                Suburb__c, 
                                                X1_Marketable_Attribute__c, 
                                                X2_Marketable_Attribute__c,
                                                X3_Marketable_Attribute__c, 
                                                Account_Name__c 
                                        FROM    Job_Seeker__c
                                        WHERE   ID = :jobSeekerID])
                {
                    tJobSeeker = js;
                }
            }
            return tJobSeeker;
        }
    }

    public Boolean IsManager
    {
        get
        {
            return CurrentUser.Profile.Name == BPConstants.Profile_BPlusManager || IsAdmin;
        }
    }

    public Boolean IsAdmin
    {
        get
        {
            return CurrentUser.Profile.Name == BPConstants.Profile_SystemAdministrator;
        }
    }

    public List<SelectOption> Consultants
    {
        get 
        {
            if(tConsultants == null)
            {
                tConsultants = getSelectListFromObjectList(SiteUsers);
            }
            return tConsultants;
        }
    }

    public List<User> SiteUsers
    {
        get 
        {
            if(tSiteUsers == null)
            {
                tSiteUsers = [SELECT    ID, 
                                        Name 
                                FROM    User
                                WHERE   IsActive = true AND 
                                        IsPortalEnabled = true 
                                ORDER BY Name];
            }
            return tSiteUsers;
        }
    }
    
    protected PageReference addMessage(String s)
    {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, s));
        return null;
    }

    protected PageReference addMessage(Exception ex)
    {
    	ApexPages.addMessages(ex);
        return null;
    }

    protected PageReference addMessage(Exception ex, Savepoint sp)
    {
        ApexPages.addMessages(ex);
        if(sp != null)
        {
            Database.rollback(sp);
        }
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

    protected List<SelectOption> getSelectListFromObjectList(List<sObject> sObjects)
    {
        return getSelectListFromObjectList(sObjects, 'ID', 'Name', true);
    }

    protected List<SelectOption> getSelectListFromObjectList(List<sObject> sObjects, Boolean addNoneOption)
    {
        return getSelectListFromObjectList(sObjects, 'ID', 'Name', addNoneOption);
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

    protected Boolean isRequiredFieldValid(object val, String fieldName, String msgSuffix, Boolean wasPreviouslyValid, Boolean displayMessage)
    {
        if(val == null || val == '')
        {
            if(displayMessage)
            {
                getRequiredFieldMessage(fieldName, msgSuffix);
            }
            return false;
        }
        return wasPreviouslyValid ? true : wasPreviouslyValid;
    }

    protected void getRequiredFieldMessage(String fieldName, String msgSuffix)
    {
        addMessage(fieldName + ' is required' + (msgSuffix == null ? '.' : msgSuffix + '.'));
    }

    public void rerenderPage()
    {}

    private void setComaptibility()
    {
        if(ApexPages.currentPage() != null)
        {
            ApexPages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=Edge');
        }
    }
}