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
    private transient Map<String, Schema.RecordTypeInfo> tCommunicationRecordTypesByName;
    private transient Live_Session__c tSession;
    private transient List<Job_Seeker_Attribute__c> tJobSeekerAttributes;
    private transient Map<String, List<Job_Seeker_Attribute__c>> tJobSeekerAttributesByGroup;
    private transient List<SelectOption> tResultOptions;
    private transient List<SelectOption> tFollowupOptions;
    private transient Attachment tUserBio;

    public BPPageBase ThisController
    {
        get
        {
            return this;
        }
    }
    public String MobileNumber
    {
        get
        {
            return getMobileNumber(JobSeeker);
        }
        set
        {
            setMobileNumber(JobSeeker, value);
        }
    }

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
        if (testErrorEnabled) {
            Integer i = 0;
            i = 1 / i;
        }
    }

    public Live_Session__c LiveSession
    {
        get
        {
            if (tSession == null) {
                tSession = getLiveSession();
            }
            return tSession;
        }
    }

    public User CurrentUser
    {
        get
        {
            if (tCurrentUser == null) {
                tCurrentUser = [
                        SELECT Id,
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
                                Contact.KPI__c,
                                Contact.Target__c,
                                AccountId,
                                Contact.Account.Name,
                                Contact.Account.Employer_Contact_Results__c,
                                Contact.Account.Followup_Results__c,
                                Contact.Account.Default_Search_Radius__c,
                                Account_Name__c,
                                BrokeredLive__c,
                                BrokeredLive_Per_EC__c,
                                UserRoleID,
                                Marketing_Only__c
                        FROM User
                        WHERE ID = :UserInfo.getUserId()
                ];
            }
            return tCurrentUser;
        }
    }

    public Attachment UserBio
    {
        get
        {
            tUserBio = new Attachment();
            for(Attachment a : [SELECT  ID,
                                        Name,
                                        Description,
                                        ContentType
                                FROM 	Attachment
                                WHERE 	ParentId = :CurrentUser.ContactID AND
                                        Description = 'Bio'])
            {
                tUserBio = a;
            }
            return tUserBio;
        }
    }

    public Job_Seeker__c JobSeeker
    {
        get
        {
            if (tJobSeeker == null) {
                tJobSeeker = new Job_Seeker__c();
                for (Job_Seeker__c js : [
                        SELECT Id,
                                Name,
                                Account__c,
                                Address_Location__c,
                                Assigned_To__c,
                                Email__c,
                                Marketing_Ended__c,
                                Marketing_Outcome__c,
                                Marketing_Started__c,
                                Professional_and_Specialist_Role__c,
                                Qualifications__c,
                                State__c,
                                Suburb__c,
                                X1_Marketable_Attribute__c,
                                X2_Marketable_Attribute__c,
                                X3_Marketable_Attribute__c,
                                Account_Name__c,
                                Placed_Date__c
                        FROM Job_Seeker__c
                        WHERE ID = :jobSeekerID
                ]) {
                    tJobSeeker = js;
                }
            }
            return tJobSeeker;
        }
    }

    public List<SelectOption> StateList
    {
        get
        {
            if (StateList == null) {
                StateList = new List<SelectOption>();
                StateList.add(new SelectOption('QLD', 'QLD'));
                StateList.add(new SelectOption('NSW', 'NSW'));
                StateList.add(new SelectOption('VIC', 'VIC'));
                StateList.add(new SelectOption('SA', 'SA'));
                StateList.add(new SelectOption('WA', 'WA'));
                StateList.add(new SelectOption('TAS', 'TAS'));
                StateList.add(new SelectOption('NT', 'NT'));
                StateList.add(new SelectOption('ACT', 'ACT'));
            }
            return StateList;
        }
        private set;
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
            if (tConsultants == null) {
                tConsultants = getSelectListFromObjectList(SiteUsers);
            }
            return tConsultants;
        }
    }

    public List<User> SiteUsers
    {
        get
        {
            if (tSiteUsers == null) {
                tSiteUsers = [
                        SELECT ID,
                                Name
                        FROM User
                        WHERE IsActive = true AND
                        IsPortalEnabled = true //AND
                        //UserRoleID = :CurrentUser.UserRoleID
                        ORDER BY Name
                ];
            }
            return tSiteUsers;
        }
    }

    public Map<String, Schema.RecordTypeInfo> CommunicationRecordTypesByName
    {
        get
        {
            if (tCommunicationRecordTypesByName == null) {
                tCommunicationRecordTypesByName = Schema.SObjectType.Communication__c.getRecordTypeInfosByName();
            }
            return tCommunicationRecordTypesByName;
        }
    }

    public List<Job_Seeker_Attribute__c> JobSeekerAttributes
    {
        get
        {
            if (tJobSeekerAttributes == null) {
                tJobSeekerAttributes = [
                        SELECT Name,
                                Group__c
                        FROM Job_Seeker_Attribute__c
                        ORDER BY Group__c,
                                Group_Order__c
                ];
            }
            return tJobSeekerAttributes;
        }
    }

    public Map<String, List<Job_Seeker_Attribute__c>> JobSeekerAttributesByGroup
    {
        get
        {
            if (tJobSeekerAttributesByGroup == null) {
                tJobSeekerAttributesByGroup = new Map<String, List<Job_Seeker_Attribute__c>>();
                for (Job_Seeker_Attribute__c attr : JobSeekerAttributes) {
                    if (!tJobSeekerAttributesByGroup.containsKey(attr.Group__c)) {
                        tJobSeekerAttributesByGroup.put(attr.Group__c, new List<Job_Seeker_Attribute__c>());
                    }
                    tJobSeekerAttributesByGroup.get(attr.Group__c).add(attr);
                }
            }
            return tJobSeekerAttributesByGroup;
        }
    }

    public Boolean IsSandbox
    {
        get
        {
            return URL.getSalesforceBaseUrl().getHost().contains('.cs5.');
        }
    }

    public Date PlacedDate
    {
        get;
        set;
    }

    public List<SelectOption> ExtraResultOptions
    {
        get
        {
            if (ExtraResultOptions == null) {
                ExtraResultOptions = new List<SelectOption>();
                String accountOptions = CurrentUser.Contact.Account.Employer_Contact_Results__c;
                if (String.isNotBlank(accountOptions)) {
                    for (String ple : accountOptions.split(';')) {
                        ExtraResultOptions.add(new SelectOption(ple, ple));
                    }
                }
            }
            return ExtraResultOptions;
        }
        private set;
    }

    public List<SelectOption> ResultOptions
    {
        get
        {
            if(tResultOptions == null)
            {
                tResultOptions = new List<SelectOption>();
                tResultOptions.add(new SelectOption('',  '--None--'));
                tResultOptions.addAll(ExtraResultOptions);
                for(PicklistEntry ple : Employer_Contact__c.Result__c.getDescribe().getPicklistValues())
                {
                    if(ple.getValue() != BPConstants.EmployerContact_Result_DoNotDisturb)
                    {
                        tResultOptions.add(new SelectOption(ple.getValue(), ple.getLabel()));
                    }
                }
            }
            return tResultOptions;
        }
    }

    public List<SelectOption> FollowupOptions
    {
        get
        {
            if(tFollowupOptions == null)
            {
                tFollowupOptions = new List<SelectOption>();
                tFollowupOptions.add(new SelectOption('',  '--None--'));
                String accountOptions = CurrentUser.Contact.Account.Followup_Results__c;
                if (String.isNotBlank(accountOptions)) {
                    for (String ple : accountOptions.split(';')) {
                        tFollowupOptions.add(new SelectOption(ple, ple));
                    }
                }
            }
            return tFollowupOptions;
        }
    }

    public PageReference placedJobSeeker()
    {
        Savepoint sp = Database.setSavepoint();
        try {
            if (JobSeeker.Placed_Date__c == null) {
                addMessage('Placed date is required.');
                return null;
            }
            String empId = getParameter('empId');
            String fuId = getParameter('fuId');
            String ecId = getParameter('ecId');
            JobSeeker.Placed_With__c = empId;
            update JobSeeker;

            PageReference pg;
            Employer_Contact__c ec;
            if (String.isNotBlank(ecId)) {
                ec = [
                        SELECT ID, (
                                SELECT ID
                                FROM Follow_Ups__r
                                WHERE Actioned__c = null
                        )
                        FROM Employer_Contact__c
                        WHERE ID = :ecId
                ];
                pg = new PageReference('/' + ecId);
            }
            else if (String.isNotBlank(fuId)) {
                ec = [
                        SELECT ID, (
                                SELECT ID
                                FROM Follow_Ups__r
                                WHERE ID = :fuId
                        )
                        FROM Employer_Contact__c
                        WHERE ID IN (
                                SELECT Employer_Contact__c
                                FROM Follow_Up__c
                                WHERE ID = :fuId
                        )
                ];
                pg = new PageReference('/' + fuId);
            }
            for (Follow_Up__c fu : ec.Follow_Ups__r) {
                fu.Action_Taken__c = BPConstants.FollowUp_Type_Placed;
                fu.Actioned__c = DateTime.now();
            }
            update ec.Follow_Ups__r;
            //addMessage(ApexPages.Severity.INFO, 'Jobseeker updated.');
            return pg;
        } catch (Exception ex) {
            return addMessage(ex, sp);
        }
    }

    protected PageReference addMessage(String s)
    {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, s));
        return null;
    }

    protected PageReference addMessage(Exception ex)
    {
        addMessage(ApexPages.Severity.ERROR, ex.getMessage() + (IsSandbox ? ('\n' + ex.getStackTraceString()) : ''));
        return null;
    }

    protected PageReference addMessage(Exception ex, Savepoint sp)
    {
        addMessage(ex);
        if (sp != null) {
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
        if (ApexPages.currentPage() == null) {
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
        if (addNoneOption) {
            optionList.add(new SelectOption('', '--None--'));
        }
        for (sObject obj : sObjects) {
            String idValue = (String) obj.get(fieldForID);
            String labelValue = (String) obj.get(fieldForLabel);
            optionList.add(new SelectOption(idValue, labelValue));
        }
        return optionList;
    }

    protected List<SelectOption> getSelectListFromPicklistField(sObjectField fieldToken, Boolean addNoneOption)
    {
        List<SelectOption> optionList = new List<SelectOption>();
        if (addNoneOption) {
            optionList.add(new SelectOption('', '--None--'));
        }
        DescribeFieldresult result = fieldToken.getDescribe();
        for (PicklistEntry ple : result.getPicklistValues()) {
            optionList.add(new SelectOption(ple.getValue(), ple.getLabel()));
        }
        return optionList;
    }


    protected Boolean isRequiredFieldValid(object val, String fieldName, Boolean wasPreviouslyValid)
    {
        return isRequiredFieldValid(val, fieldName, null, wasPreviouslyValid, true);
    }

    protected Boolean isRequiredFieldValid(object val, String fieldName, String msgSuffix, Boolean wasPreviouslyValid, Boolean displayMessage)
    {
        if (val == null || val == '') {
            if (displayMessage) {
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

    protected Boolean validateMobileNumber(String s)
    {
        return validateMobileNumber(s, true);
    }

    protected Boolean validateMobileNumber(String s, Boolean throwException)
    {
        if (String.isBlank(s)) {
            if (throwException) {
                throw new BPException('Mobile phome number is required');
            }
            return false;
        }
        if (BPSMSUtilities.cleanPhoneNumber(s, throwException) == null) {
            return false;
        }
        return true;
    }

    protected Live_Session__c getLiveSession()
    {
        String sessID = getParameter('sessId');
        String chkId = getParameter('chkId');
        for (Live_Session__c ls : [
                SELECT ID,
                        Job_Seeker__c,
                        Job_Seeker__r.Name,
                        Job_Seeker__r.Address_Location__c,
                        Job_Seeker__r.Account__c,
                        X1_Marketable_Attribute__c,
                        X2_Marketable_Attribute__c,
                        X3_Marketable_Attribute__c
                FROM Live_Session__c
                WHERE ID = :sessID AND
                Job_Seeker__c = :chkId
        ]) {
            return ls;
        }
        return new Live_Session__c();
    }

    protected String getMobileNumber(Job_Seeker__c js)
    {
        if (!Test.isRunningTest() && Cache.Session.get('local.UserSession.mobileNumber') == null) {
            Cache.Session.put('local.UserSession.mobileNumber', new Map<String, String>());
        }
        Map<String, String> numbersByJskId = Test.isRunningTest() ? null : (Map<String, String>) Cache.Session.get('local.UserSession.mobileNumber');
        if (numbersByJskId == null) {
            numbersByJskId = new Map<String, String>();
        }
        return Test.isRunningTest() ? '0404240508' : numbersByJskId.get(js.ID);
    }

    protected void setMobileNumber(Job_Seeker__c js, String num)
    {
        if (!Test.isRunningTest() && Cache.Session.get('local.UserSession.mobileNumber') == null) {
            Cache.Session.put('local.UserSession.mobileNumber', new Map<String, String>());
        }
        Map<String, String> numbersByJskId = Test.isRunningTest() ? null : (Map<String, String>) Cache.Session.get('local.UserSession.mobileNumber');
        if (numbersByJskId == null) {
            numbersByJskId = new Map<String, String>();
        }
        if (js.ID != null) {
            numbersByJskId.put(js.ID, num);
        }
        if (!Test.isRunningTest()) {
            Cache.Session.put('local.UserSession.mobileNumber', numbersByJskId);
        }
    }

    public void rerenderPage()
    {
    }

    private void setComaptibility()
    {
        if (ApexPages.currentPage() != null) {
            ApexPages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=Edge');
        }
    }
}