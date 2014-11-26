public with sharing class EmployerSearchController 
    extends BPPageBase
{
    public EmployerSearchController(ApexPages.StandardController ctrlr)
    {
        Radius = 5;
        controller = ctrlr;        
    }
    
    private transient String tCategoryIds = null; 
    private ApexPages.StandardController controller;
    private String jobID;
    private String industryID;
    private String categoryID;
    
    public Job_Seeker__c JobSeeker
    {
        get
        {
            if(JobSeeker == null)
            {
                JobSeeker = [SELECT Id, 
                            Name, 
                            Address_Location__c, 
                            State__c,
                            Mobile__c, 
                            Email__c, 
                            JSK_ID__c, 
                            Marketing_Started__c, 
                            Marketing_Ended__c, 
                            Professional_and_Specialist_Role__c,
                            Suburb__c,
                            Account__c,
                            Account__r.Name,
                            (SELECT Sent__c
                            FROM    SMS_Notifications__r
                            WHERE   Type__c = :BPConstants.SMSMNotification_Type_CommencedMarketing AND
                                    Sent__c != null
                            ORDER BY Sent__c DESC 
                            LIMIT 1) 
                    FROM    Job_Seeker__c
                    WHERE   ID = :controller.getID()];
            }
            return JobSeeker;
        }
        private set;
    }

    public String SearchType
    {
        get;
        set;
    }

    public Integer Radius
    {
        get;
        set;
    }

    public Employer_Contact__c EmployerContact 
    {
        get
        {
            if(EmployerContact == null)
            {
                EmployerContact = new Employer_Contact__c(Job_Seeker__c = JobSeeker.ID, User__c = UserInfo.getUserId());
            }
            return EmployerContact;
        }
        set;
    }

    public Business__c SelectedBusiness 
    {
        get
        {
            if(SelectedBusiness == null)
            {
                SelectedBusiness = new Business__c();
            }
            return SelectedBusiness;
        }
        set;
    }

    public Map<String, Business__c> BusinessessBySensisID
    {
        get
        {
            if(BusinessessBySensisID == null)
            {
                BusinessessBySensisID = new Map<String, Business__c>();
            }
            return BusinessessBySensisID;
        }
        set;
    }
    
    public String MapUrl
    {
        get
        {
            String loc = String.isBlank(JobSeeker.Address_Location__c) ? '' : JobSeeker.Address_Location__c;
            return 'https://www.google.com/maps/embed/v1/directions?key=AIzaSyC5dNoiCj4SXJbISryuN9pRPADrH62Ki-Q&origin=' +
                    EncodingUtil.urlEncode(loc, 'UTF-8') +  
                    '&mode=transit&destination=';
        }
    }

    public String EmployerLocation
    {
        get;
        set;
    }
    
    public String NextAddress
    {
        get;
        set;
    }

    @TestVisible
    public String CurrentPage
    {
        get;
        private set
        {
            CurrentPage = value;
        }
    }

    public String TotalPages
    {
        get;
        private set;
    }

    public List<Job__c> Top40Jobs
    {
        get
        {
            if(Top40Jobs == null)
            {
                Top40Jobs = [SELECT ID, 
                                    Name 
                            FROM    Job__c  
                            ORDER BY Name];
            }
            return Top40Jobs;
        }
        set;
    }

    public List<Job_Category__c> TargetedJobCategories
    {
        get
        {
            if(TargetedJobCategories == null)
            {
                TargetedJobCategories = [SELECT ID, 
                                                Name,
                                                Parent_Category__c,
                                                Parent_Category__r.Name
                                        FROM    Job_Category__c
                                        WHERE   Targeted__c = true
                                        ORDER BY Parent_Category__c,
                                                Name];
            }
            return TargetedJobCategories;
        }
        private set;
    }

    public Map<String, List<Industry__c>> IndustriesByIndex
    {
        get
        {
            if(IndustriesByIndex == null)
            {
                IndustriesByIndex = new Map<String, List<Industry__c>>();
                String key = null;
                for(Industry__c i : [SELECT ID, 
                                            Name,
                                            Initial__c
                                    FROM    Industry__c
                                    ORDER BY Name])
                {
                    if(i.Initial__c <= 'F')
                    {
                        key = 'A - F';
                    }
                    else if(i.Initial__c <= 'M')
                    {
                        key = 'G - M';
                    }
                    else if(i.Initial__c <= 'S')
                    {
                        key = 'N - S';
                    }
                    else
                    {
                         key = 'T - Z';
                    }
                    if(!IndustriesByIndex.containsKey(key))
                    {
                        IndustriesByIndex.put(key, new  List<Industry__c>());
                    }
                    IndustriesByIndex.get(key).add(i);
                }
            }
            return IndustriesByIndex;
        }
        private set;
    }
    
    @TestVisible
    public List<SensisResponse.Results> SearchResults
    {
        get
        {
            if(SearchResults == null)
            {
                SearchResults = new List<SensisResponse.Results>();
            }
            return SearchResults;
        }
        private set;
    }

    public Account CommunityAccount
    {
        get
        {
            if(CommunityAccount == null)
            {
                 CommunityAccount= [SELECT  ID,
                                            Name
                                            //IsCustomerPortal
                                    FROM    Account 
                                    LIMIT 1];
            }
            return CommunityAccount;
        }
        set;
    }

    public void saveContact()
    {
        try
        {
            throwTestError();
            doSaveContact();
        }
        catch(Exception ex)
        {
            addMessage(ex);
        } 
    }

    public PageReference goJobseeker()
    {
        try
        {
            throwTestError();
            doSaveContact();
            PageReference pg = Page.JobSeekerView;
            pg.getParameters().put('id', JobSeeker.ID);
            return pg.setRedirect(true);
        }
        catch(Exception ex)
        {
            return addMessage(ex);
        } 
    }

    public PageReference goHome()
    {
        try
        {
            throwTestError();
            doSaveContact();
            PageReference pg = Page.BrokeredPlusHome;
            return pg.setRedirect(true);
        }
        catch(Exception ex)
        {
            return addMessage(ex);
        } 
    }

    public void getEmployer()
    {
        try
        {
            throwTestError();        
            if(SelectedBusiness.Sensis_ID__c != null)
            {
                 doSaveContact();
            }
            getNextEmployer(true);
        }
        catch(Exception ex)
        {
            addMessage(ex);
        }
    }
    
    public void doIndustrySearch()
    {
        try
        {
            throwTestError();
            String param = getParameter('industryId');   
            industryId = param == null ? industryId : param;         
            SearchType = 'Industry';
            doSearch(getCategoryIds(null, null, industryId));  
        }
        catch(Exception ex)
        {
            addMessage(ex);
        }
    }

    public void doJobSearch()
    {
        try
        {   
            throwTestError();
            String param = getParameter('categoryId');
            categoryId = param == null ? categoryId : param;
            SearchType = 'Targeted';            
            doSearch(getCategoryIds(null, categoryId, null));                 
        }
        catch(Exception ex)
        {
            addMessage(ex);
        }
    }

    public void doSurvivalJobSearch()
    {
        try
        {
            throwTestError();
            String param = getParameter('jobId');
            jobID = param == null ? jobId : param;
            SearchType = 'Survival';
            doSearch(getCategoryIds(jobID, null, null));  
        }
        catch(Exception ex)
        {
            addMessage(ex);
        }
    } 

    private void doSearch(String categoryIds)
    {
        String nextPage = getNextPage(getParameter('currPg'));
        String location = String.isBlank(EmployerLocation) ? JobSeeker.Address_Location__c : (EmployerLocation + ',' + JobSeeker.State__c);
        SearchResults = null;
        SensisSearchController sensisSearch = new SensisSearchController();    

        SearchResults = sensisSearch.doSearchByCategory(categoryIds, location, Radius.format(), nextPage);            
        getBusinessDetails();  
        CurrentPage = sensisSearch.PageNumber;
        TotalPages = sensisSearch.TotalPages;   
    }

    private void doSaveContact()
    {
        if(SelectedBusiness.Sensis_ID__c == null)
        {
            return;
        }
        if(EmployerContact.Result__c == null)
        {
            throw new BPException('Result is required.');
        }
        if(EmployerContact.Result__c == BPConstants.EmployerContact_Result_Interview &&
                    (EmployerContact.Interview_Date__c == null ||
                        EmployerContact.Interview_Time__c == null))
        {
            throw new BPException('Interview Date and Time is required.');
        }
        if(EmployerContact.Result__c == BPConstants.EmployerContact_Result_ResumeDropOff &&
                EmployerContact.Meeting_Time__c == null)
        {
            throw new BPException('Meeting Date and Time is required.');
        }
        SMS_Notification__c notification = null;
        if(String.isNotBlank(JobSeeker.Mobile__c) &&
                (JobSeeker.SMS_Notifications__r.isEmpty() || 
                JobSeeker.SMS_Notifications__r[0].Sent__c < Datetime.now().addDays(-7)))
        {
            String message = CommunityAccount.Name + ' has commenced marketing you to employers';
            String phNumber = BPSMSUtilities.cleanPhoneNumber(JobSeeker.Mobile__c);
            String smsReference = BPSMSUtilities.sendSMS(message, phNumber, null); 
            notification = new SMS_Notification__c(Job_Seeker__c = JobSeeker.ID,
                                                    Number__c = phNumber,
                                                    Message__c = message,
                                                    Type__c = BPConstants.SMSMNotification_Type_CommencedMarketing);
            if(smsReference != null)
            {
                notification.Sent__c = Datetime.now();
                notification.Gateway_Reference__c = smsReference;
                
            }
                         
        }       
        if(EmployerContact.Result__c == 'Do not disturb')
        {
            SelectedBusiness.Do_Not_Disturb_Expiry__c = Date.today().addMonths(3);
        }
        SelectedBusiness.Last_Contacted__c = Date.today(); 
        SelectedBusiness.Last_Contacted_By__c = UserInfo.getUserId(); 
        SelectedBusiness.Last_Result__c = EmployerContact.Result__c;

        EmployerContact.Business__c = SelectedBusiness.ID;
        if(JobSeeker.Marketing_Started__c == null)
        {
            JobSeeker.Marketing_Started__c = Date.today();
            update JobSeeker;
        }
        upsert SelectedBusiness;
        upsert EmployerContact; 
        if(notification != null)
        {
            insert notification;
        }
        JobSeeker = null;
    }

    @TestVisible
    private String getNextPage(String currPage)
    {
        if(String.isNotBlank(currPage) && currPage.isNumeric())
        {
            return String.valueOf(Integer.valueOf(currPage) + 1);
        }
        return null;
    }

    private void getNextEmployer(Boolean noPreviousEmployer)
    {
        String sensisId = getParameter('sensisId');
        EmployerContact = null;
        SelectedBusiness = null;
        NextAddress = null;
        for(Integer i = 0; i < SearchResults.size(); i++) 
        {
            if(SearchResults[i].id == sensisId)
            {               
                NextAddress = SearchResults[i].MapAddress;
                SelectedBusiness = SearchResults[i].Business;
                EmployerContact.Contact_Number__c = SearchResults[i].ContactNumber;
                EmployerContact.Contacted_On__c = Datetime.now();
                break;
            }
        }
    }

    private void getBusinessDetails()
    {
        Set<String> sensisIds = new Set<String>();

        /*if(SearchResults.size() > 0)
        {
            NextAddress = SearchResults[0].MapAddress;
        }*/
        for(SensisResponse.Results result : SearchResults)
        {          
            result.Name = result.Name.replace('\'', '');
            sensisIds.add(result.id);
        }

        BusinessessBySensisID = null;
        for(Business__c business : [SELECT  ID,
                                            Name,
                                            Last_Contacted__c,
                                            Do_Not_Disturb_Expiry__c,
                                            Sensis_ID__c,
                                            Account__c,
                                            Account__r.Name,
                                            Last_Contacted_By__c,
                                            Last_Result__c
                                    FROM    Business__c
                                    WHERE   Sensis_ID__c IN :sensisIds AND 
                                            Sensis_ID__c != null])
        {
            BusinessessBySensisID.put(business.Sensis_ID__c, business);
        }

        for(SensisResponse.Results result : SearchResults)
        {
            if(BusinessessBySensisID.containsKey(result.id))
            {           
                result.Business = BusinessessBySensisID.get(result.id);
            }
            else
            {
                result.Business = new Business__c(Name = result.Name,
                                                Account__c = CommunityAccount.ID, 
                                                Sensis_ID__c = result.id);
                BusinessessBySensisID.put(result.id, result.Business);
            }
        }
    }

    private String getCategoryIds(String jobID, String jobCategory, String industryId)
    {
        String categories = '';
        List<Industry__c> industries = new List<Industry__c>();
        Set<ID> jobCategoryIds = new Set<ID>();
        Set<ID> industryIds = new Set<ID>();
        if(String.isNotBlank(jobID))
        {
            for(Job_Industry__c ji : [SELECT ID,
                                            Industry_Sensis_Category_ID__c
                                    FROM    Job_Industry__c
                                    WHERE   Job__c = :jobID])
            {
                categories += addCategoryID(ji.Industry_Sensis_Category_ID__c);
            }
            return categories;
        }

        if(String.isNotBlank(jobCategory))
        { 
            jobCategoryIds.add(jobCategory);
            industries = [SELECT Sensis_Category_ID__c
                        FROM    Industry__c 
                        WHERE   Job_Category__c = :jobCategory OR 
                                Job_Category2__c = :jobCategory OR
                                Job_Category3__c = :jobCategory
                        LIMIT 500];
        }
        
        if(String.isNotBlank(industryId))
        {               
            industries = [SELECT    Sensis_Category_ID__c 
                            FROM    Industry__c 
                            WHERE   ID = :industryId]; 
        }
        else
        {
            industries = [SELECT    Sensis_Category_ID__c 
                            FROM    Industry__c
                            WHERE   Job_Category__c != null AND 
                                    (
                                        ID IN :industryIds OR
                                        (Job_Category__c  IN :jobCategoryIds OR 
                                        Job_Category2__c  IN :jobCategoryIds OR
                                        Job_Category3__c  IN :jobCategoryIds)
                                    )]; 
        }
        for(Industry__c industry : industries)
        {
            categories += addCategoryID(industry.Sensis_Category_ID__c);
            /*if(categories.length() > 1700)
            {
                //throw new BPException('Too many categories to search. Please select a subcategory.');
                return categories;
            }*/
        }
        return categories;
    }

    private String addCategoryID(String categoryId)
    {
        return '&categoryId=' + categoryId;
    }
}