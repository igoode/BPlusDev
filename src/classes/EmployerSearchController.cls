public with sharing class EmployerSearchController 
    extends BPPageBase
{
    public EmployerSearchController()
    {
        Radius = CurrentUser.Contact.Account.Default_Search_Radius__c == null ? 5 :CurrentUser.Contact.Account.Default_Search_Radius__c.intValue();
        BrokeredLive = true;
    }

    public EmployerSearchController(ApexPages.StandardController ctrlr)
    {
        Radius = CurrentUser.Contact.Account.Default_Search_Radius__c == null ? 5 :CurrentUser.Contact.Account.Default_Search_Radius__c.intValue();
        controller = ctrlr;   
           
        BrokeredLive = false;
        if(CurrentUser.Marketing_Only__c)
        {
            SearchLocation = JobSeeker.Last_Marketed_Search_Location__c;
            SearchState = JobSeeker.Last_Marketed_Search_State__c;
            ShowResume = String.isNotBlank(JobSeeker.Last_Marketed_Search_Location__c);
        }
        else 
        {
             ShowResume = JobSeeker.Last_Marketed_EC__c == UserInfo.getUserId();
        }
    }

    private final String KEYWORDSEARCH = 'Keyword';
    private final String INDUSTRYSEARCH = 'Industry';
    private final String TARGETEDSEARCH = 'Targeted';       
    private final String TOP40SEARCH = 'Top40'; 
	private final String GOOGLE = 'Google';     

    private transient String tCategoryIds = null; 
    private transient List<SelectOption> tResultOptions;
    private transient List<ABRSearch.ABRResult> tABRResults;
    private ApexPages.StandardController controller;
    private String jobID;
    private String industryID;
    private String categoryID;

    public String NextPageToken
    {
        get;
        set;
    }

    public Boolean BrokeredLive
    {
        get;
        set;
    }

    public String ReferralTo
    {
        get;
        set;
    }
    
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
                            Email__c, 
                            Marketing_Started__c, 
                            Marketing_Ended__c, 
                            Professional_and_Specialist_Role__c,
                            Do_not_disclose_JSK_barriers__c,
                            Last_Marketed_EC__c,
                            Last_Marketed_Page__c,
                            Last_Marketed_Search_Category__c,
                            Last_Marketed_Search_Type__c,
                            Last_Marketed_Search__c,
                            Last_Marketed_Search_Radius__c,
                            Last_Marketed_Alt_Location__c,
                            Last_Marketed_Search_Location__c,
                            Last_Marketed_Search_State__c,
                            X1_Marketable_Attribute__c,
                            X2_Marketable_Attribute__c,
                            X3_Marketable_Attribute__c,
                            Suburb__c,
                            Account__c,
                            Account__r.Name,
                            (SELECT Sent__c
                            FROM    Communications__r
                            WHERE   RecordType.Name = :BPConstants.Communication_RecordType_SMSNotification AND
                                    Type__c = :BPConstants.SMSMNotification_Type_CommencedMarketing AND
                                    Sent__c != null
                            ORDER BY Sent__c DESC 
                            LIMIT 1) 
                    FROM    Job_Seeker__c
                    WHERE   ID = :(controller == null ? LiveSession.Job_Seeker__c : controller.getID())];
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

    public Boolean ShowResume
    {
        get;
        set;
    }

    public Integer Radius
    {
        get;
        set;
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

	public String SearchLocation
    {
        get;
		set;
    }

	public String SearchState
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
                EmployerContact = new Employer_Contact__c(Job_Seeker__c = JobSeeker.ID, 
                                                        User__c = BrokeredLive ? null : UserInfo.getUserId(),
                                                        Live_Session__c =  BrokeredLive ? LiveSession.ID : null);
            }
            return EmployerContact;
        }
        set;
    }

    public Follow_Up__c EmployerFollowUp 
    {
        get
        {
            if(EmployerFollowUp == null)
            {
                EmployerFollowUp = new Follow_Up__c(Job_Seeker__c = JobSeeker.ID, 
                                            Assigned_To__c = UserInfo.getUserId(),
                                            Type__c = BPConstants.FollowUp_Type_CallEmployer,
                                            RecordTypeID = BPConstants.FollowUp_RecordType_Followup_ID);
            }
            return EmployerFollowUp;
        }
        set;
    }

    public Follow_Up__c JobseekerFollowUp 
    {
        get
        {
            if(JobseekerFollowUp == null)
            {
                JobseekerFollowUp = new Follow_Up__c(Job_Seeker__c = JobSeeker.ID, 
                                            Assigned_To__c = UserInfo.getUserId(),
                                            Type__c = BPConstants.FollowUp_Type_CallJobseeker,
                                            RecordTypeID = BPConstants.FollowUp_RecordType_Followup_ID);
            }
            return JobseekerFollowUp;
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
			if(CurrentUser.Marketing_Only__c) 
			{
				return 'https://www.google.com/maps/embed/v1/place?key=AIzaSyC5dNoiCj4SXJbISryuN9pRPADrH62Ki-Q' +
                    '&q=';
			}
			String loc = String.isBlank(JobSeeker.Address_Location__c) ? '' : JobSeeker.Address_Location__c;
            return 'https://www.google.com/maps/embed/v1/directions?key=AIzaSyC5dNoiCj4SXJbISryuN9pRPADrH62Ki-Q&origin=' +
                    EncodingUtil.urlEncode(loc, 'UTF-8') +  
                    '&mode=transit&destination=';
        }
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

    public String SearchABNName
    {
        get;
        set;
    }

    public List<ABRSearch.ABRResult> ABRResults
    {
        get
        {
            return tABRResults;
        }
    }

    public String EmployerLocation
    {
        get;
        set;
    }

	public String EmployerLocationLatLong
	{
        get;
        set;
    }

    public String EmployerURL
    {
        get;
        set;
    }

    public String Keyword
    {
        get;
        set;
    }
    
    public String NextAddress
    {
        get;
        set;
    }

    public String NextAddressDisplay
    {
        get
        {
            return String.isBlank(NextAddress ) ? '' : EncodingUtil.urlDecode(NextAddress, 'UTF-8');
        }
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

    @TestVisible
    public String PrevPage
    {
        get;
        private set;
    }
	
    @TestVisible
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

    public List<Job_Category__c> TradeJobCategories
    {
        get
        {
            if(TradeJobCategories == null)
            {
                TradeJobCategories = [SELECT ID,
                                            Name,
                                            Parent_Category__c,
                                            Parent_Category__r.Name
                                    FROM    Job_Category__c
                                    WHERE   Trade__c = true
                                    ORDER BY Name];
            }
            return TradeJobCategories;
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
                if(BrokeredLive)
                {                
                    CommunityAccount = [SELECT  ID,
                                                Name
                                        FROM    Account 
                                        WHERE ID = :LiveSession.Job_Seeker__r.Account__c];                                       
                }
                else
                {
                    CommunityAccount= [SELECT  ID,
                                                Name
                                        FROM    Account 
                                        LIMIT 1];
                }
            }
            return CommunityAccount;
        }
        set;
    }

    public void saveContact()
    {
        Savepoint sp = Database.setSavepoint();
        try
        {
            throwTestError();
            Boolean createSignupFollwup = false;
            if(EmployerContact.Result__c != null &&
                    EmployerContact.Result__c.endsWith(BPConstants.EmployerContact_Result_Signup))
            {
                if(String.isBlank(ReferralTo))
                {
                    createSignupFollwup = true;
                }
                else
                {
                    EmployerContact.Result__c = BPConstants.EmployerContact_Result_Referral;
                }
            }
            doSaveContact();
            if(createSignupFollwup)
            {
                BPEmployerExtension.createSignupFollowup(EmployerContact);
            }

            if(CurrentUser.Marketing_Only__c &&
                    EmployerContact.Result__c == BPConstants.EmployerContact_Result_Referral &&
                    String.isNotBlank(ReferralTo))
            {
                BPEmployerExtension.createReferral(EmployerContact, ReferralTo);
            }

            if(EmployerFollowUp.Due_Date__c != null)
            {
                if(EmployerFollowUp.Employer_Contact__c == null)
                {
                    EmployerFollowUp.Employer_Contact__c = EmployerContact.ID;
                }
                upsert EmployerFollowUp;
            }
            if(JobseekerFollowUp.Due_Date__c != null)
            {
                if(JobseekerFollowUp.Employer_Contact__c == null)
                {
                    JobseekerFollowUp.Employer_Contact__c = EmployerContact.ID;
                }
                upsert JobseekerFollowUp;
            }
        }
        catch(Exception ex)
        {
            addMessage(ex, sp);
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

    public void notifyJobSeeker()
    {
        try
        {
            throwTestError();
            if(!validateMobileNumber(MobileNumber, false))
            {
                return;
            }  
			Boolean notifiedLately = false;
			for(Communication__c comm : [SELECT ID,
												Sent__c
										FROM	Communication__c
										WHERE	Job_Seeker__c = :JobSeeker.ID AND 
												RecordType.Name = :BPConstants.Communication_RecordType_SMSNotification AND
												Type__c = :BPConstants.SMSMNotification_Type_CommencedMarketing AND 
												Sent__c != null
										ORDER BY Sent__c DESC 
										LIMIT 1])
			{
				notifiedLately = comm.Sent__c > Datetime.now().addDays(-7);
			}
			if(!notifiedLately)
			{
				sendJobSeekerNotification(JobSeeker.ID, CommunityAccount.Name, MobileNumber);          
			}
        }
        catch(Exception ex)
        {
            addMessage(ex);
        }
    }

    public void getEmployer()
    {
        try
        {
            throwTestError();        
            getNextEmployer(true);
        }
        catch(Exception ex)
        {
            addMessage(ex);
        }
    }

    public void clearSearch()
    {
        SearchResults = null;
        EmployerContact = null;
        SelectedBusiness = null;
        NextAddress = '';
        EmployerURL = null;
    }

    public void resumeSearch()
    {
        JobSeeker.Last_Marketed_EC__c = UserInfo.getUserID();
        CurrentPage = JobSeeker.Last_Marketed_Page__c;
        SearchType = JobSeeker.Last_Marketed_Search_Type__c;
        Radius = JobSeeker.Last_Marketed_Search_Radius__c == null ? 5 : JobSeeker.Last_Marketed_Search_Radius__c.intValue();
        EmployerLocation = JobSeeker.Last_Marketed_Alt_Location__c;
        if(SearchType == KEYWORDSEARCH)
        {
            Keyword = JobSeeker.Last_Marketed_Search_Category__c;
            //doSearch(null, CurrentPage, EmployerLocation);
			doKeywordSearch();
        }
		else if(SearchType == GOOGLE)
        {
            Keyword = JobSeeker.Last_Marketed_Search_Category__c;
            doGoogleSearch();
        }
        else
        {
            doSearch(JobSeeker.Last_Marketed_Search_Category__c, CurrentPage, EmployerLocation);
        }
    }
    
    public void doIndustrySearch()
    {
        try
        {
            throwTestError();
            String param = getParameter('industryId');   
            industryId = param == null ? industryId : param;         
            SearchType = INDUSTRYSEARCH;
            doSearch(getCategoryIds(null, null, industryId), null);  
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
            //SearchType = TARGETEDSEARCH;
            doSearch(getCategoryIds(null, categoryId, null), null);                 
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
            SearchType = TOP40SEARCH;
            doSearch(getCategoryIds(jobID, null, null), null);  
        }
        catch(Exception ex)
        {
            addMessage(ex);
        }
    } 

	public void doKeywordSearch()
    {
        try
        {
            throwTestError();
            SearchType = KEYWORDSEARCH;
            doSearch(null, null);    
        }
        catch(Exception ex)
        {
            addMessage(ex);
        }
    } 

    public void doGoogleSearch()
    {
        try
        {
            throwTestError();
            SearchType = GOOGLE;
            String employerLocation = getLocation(null);
			GooglePlacesJSON placesJSON = GooglePlaces.search(Keyword, Radius.format() + '000', employerLocation, EmployerLocationLatLong, NextPageToken);
            NextPageToken = placesJSON.next_page_token;
system.debug(NextPageToken);
            if (String.isBlank(EmployerLocationLatLong))
            {
                Location loc = GooglePlaces.getLocation(employerLocation);
                EmployerLocationLatLong = String.valueOf(loc.getLatitude()) + ',' + String.valueOf(loc.getLongitude());
            }
			SearchResults = SensisResponse.convertFromGooglePlaces(placesJSON, EmployerLocationLatLong, Radius).Results;
			getSearchBusinesses('1', String.valueOf(SearchResults.size()), null);   
			TotalPages = '1';
        }
        catch(Exception ex)
        {
            addMessage(ex);
        }
    }

//    public void doTradeSearch()
//    {
//
//    }

    public void sendEmails()
    {

    }

    public void searchABN()
    {
        try
        {
            tABRResults = ABRSearch.getABN(SearchABNName);
        }
        catch(CalloutException cex)
        {
            if(cex.getMessage() == 'Read timed out')
            {
                addMessage('Search took too long, try a more precise name to search on');
            }
            else
            {
                addMessage(cex);
            }
        }
        catch(Exception ex)
        {
            addMessage(ex);
        }
    }

    public void sendEmployerDetails()
    {
        try
        {
            throwTestError();
            validateMobileNumber(MobileNumber);
            List<Communication__c> notifications = new List<Communication__c>();
            String type;
            if(EmployerContact.Result__c == BPConstants.EmployerContact_Result_Interview)
            {
                type = 'have an ' + BPConstants.EmployerContact_Result_Interview + ' with ';
            }
            else
            {
                type = 'drop off your resume at ';
            }
            String message = CommunityAccount.Name + ' has arranged for you to ' + type + 
                        SelectedBusiness.Name + ' ' +
                        EmployerContact.Address__c +
                        ' on ' + EmployerContact.Interview_Date__c.format() + 
                        ' at ' + EmployerContact.Interview_Time__c + 
                        '. Please notify us if you are unable to attend.';

            notifications.add(BPFollowupExtension.sendSMS(JobSeeker, message, EmployerContact.Result__c, MobileNumber));
            addMessage(ApexPages.Severity.INFO, 'SMS sent.');
            insert notifications;
        }
        catch(Exception ex)
        {
            addMessage(ex);
        }
    }

	@future(callout=true)
	public static void sendJobSeekerNotification(ID jobseekerId, String accountName, String mobileNumber)
	{
		for(Job_Seeker__c js : [SELECT Id, 
										Name 
								FROM	Job_Seeker__c
								WHERE	ID = :jobseekerId])
										
		{
			String msg = 'Hi ' + js.Name +', ' + accountName + ' has commenced marketing you to employers. Please contact the office if you have any queries.';
			Communication__c notification = BPFollowupExtension.sendSMS(js, 
                                                    msg, 
                                                    BPConstants.SMSMNotification_Type_CommencedMarketing,
                                                    mobileNumber); 
			insert notification;  
		}		
	} 
	
	private void doSearch(String categoryIds, String resumeFromPage)  
	{
		doSearch(categoryIds, resumeFromPage, null);
	}   
    
    private void doSearch(String categoryIds, String resumeFromPage, String resumeLocation)
    {
        SelectedBusiness = null;
        NextAddress = '';
        EmployerContact = null;
        EmployerURL = null;
        String nextPage = String.isBlank(resumeFromPage) ? getNextPage(getParameter('prevPage')) : resumeFromPage;       
        if(String.isNotBlank(nextPage))
        {
            nextPage = nextPage == '0' ? '' : nextPage;
        }
        else 
        {
            nextPage = getNextPage(getParameter('currPg'));
        }     
		String location = getLocation(resumeLocation);
        SearchResults = null;
        SensisSearchController sensisSearch = new SensisSearchController();    
        if(categoryIds == null)
        {
            SearchResults = sensisSearch.doSearchByQuery(Keyword, location, Radius.format(), nextPage);
        }
        else
        {
            SearchResults = sensisSearch.doSearchByCategory(categoryIds, location, Radius.format(), nextPage); 
        }  
		getSearchBusinesses(sensisSearch.PageNumber, sensisSearch.TotalPages, categoryIds);   
    }

	private void getSearchBusinesses(String pageNumber, String totPages, String categoryIds)
	{
		getBusinessDetails(); 
        CurrentPage = pageNumber;
        if(!BrokeredLive)
        {
            notifyJobSeeker();
			JobSeeker.Last_Marketed_EC__c = UserInfo.getUserID();
            JobSeeker.Last_Marketed_Page__c = CurrentPage;
            JobSeeker.Last_Marketed_Search_Category__c = (SearchType == KEYWORDSEARCH || SearchType == GOOGLE) ? Keyword : categoryIds;
            JobSeeker.Last_Marketed_Search_Type__c = SearchType;
            JobSeeker.Last_Marketed_Search_Radius__c = Radius;
            JobSeeker.Last_Marketed_Alt_Location__c = EmployerLocation;
            JobSeeker.Last_Marketed_Search_Location__c = SearchLocation;
            JobSeeker.Last_Marketed_Search_State__c = SearchState;
            JobSeeker.Last_Marketed_Searched_On__c = Datetime.now();
            String lastSearch = getParameter('selSrch');
            if(String.isNotBlank(lastSearch))
            {
                JobSeeker.Last_Marketed_Search__c = lastSearch;
            }
            update JobSeeker;
        }

        PrevPage = null;
        if(String.isNotBlank(CurrentPage) && CurrentPage.isNumeric())
        {
            Integer pageNo = Integer.valueOf(CurrentPage);
            if(pageNo > 1)
            {                
                PrevPage = String.valueOf(pageNo - 2);
            }
        }       
        TotalPages = totPages; 
	}

    private void doSaveContact()
    {
        if(SelectedBusiness.Sensis_ID__c == null && SelectedBusiness.Google_Place_Id__c == null)
        {
            return;
        }
        if(EmployerContact.Result__c == null)
        {            
            return;
        }
        if(EmployerContact.Result__c == BPConstants.EmployerContact_Result_Interview &&
                    (EmployerContact.Interview_Date__c == null ||
                    EmployerContact.Interview_Time__c == null))
        {
            throw new BPException('Interview Date and Time is required.');
        }
        if(EmployerContact.Result__c == BPConstants.EmployerContact_Result_ResumeDropOff &&
                (EmployerContact.Interview_Date__c == null ||
                EmployerContact.Interview_Time__c == null))
        {
            throw new BPException('Meeting Date and Time is required.');
        }
        if(!BrokeredLive)
        {
            if(EmployerContact.Result__c == BPConstants.EmployerContact_Result_DoNotDisturb)
            {
                SelectedBusiness.Do_Not_Disturb_Expiry__c = Date.today().addMonths(3);
            }
            
            SelectedBusiness.Last_Contacted__c = DateTime.now(); 
            SelectedBusiness.Last_Contacted_By__c = UserInfo.getUserId(); 
            SelectedBusiness.Last_Result__c = EmployerContact.Result__c;
            if(JobSeeker.Marketing_Started__c == null)
            {
                JobSeeker.Marketing_Started__c = Date.today();
                update JobSeeker;
            }
        }
		if(SelectedBusiness.Lat__c != null && SelectedBusiness.Long__c != null)
		{
			Location l = Location.newInstance(SelectedBusiness.Lat__c, SelectedBusiness.Long__c);
			SelectedBusiness.LatLong__Latitude__s = l.getLatitude();
			SelectedBusiness.LatLong__Longitude__s = l.getLongitude();
		}
        upsert SelectedBusiness;
		
        if(EmployerContact.Business__c == null)
        {
            EmployerContact.Business__c = SelectedBusiness.ID;
        }   
        upsert EmployerContact;  

        if(!BrokeredLive && EmployerContact.Result__c == BPConstants.EmployerContact_Result_Vacancy)
        {
			Follow_Up__c followup = new Follow_Up__c(Employer_Contact__c = EmployerContact.ID, 
													Result__c = BPConstants.EmployerContact_Result_Vacancy,
                                                    RecordTypeID = BPConstants.FollowUp_RecordType_Followup_ID);
            // if  this was an update need to change the triggered followup
            for(Follow_Up__c fu : [SELECT	ID 
									FROM    Follow_Up__c
									WHERE   RecordTypeID = :BPConstants.FollowUp_RecordType_Followup_ID AND
                                            Employer_Contact__c = :EmployerContact.ID AND
											Employer_Contact__c != null AND 
											Result__c = :BPConstants.EmployerContact_Result_Vacancy])
            {
                followup = fu;
            }
			followup.Open_Vacancy__c = EmployerContact.Open_Vacancy__c;
			followup.Assigned_To__c = followup.Open_Vacancy__c ? null : UserInfo.getUserId();
			followup.Job_Seeker__c = null;
            upsert followup;
            
			if(EmployerContact.Open_Vacancy__c)
			{
				EmailTemplate template = [SELECT ID 
										FROM    EmailTemplate 
										WHERE   DeveloperName = :BPConstants.EmailTemplate_OpenVacancy];

				List<Messaging.SingleEmailMessage> msgs = new List<Messaging.SingleEmailMessage>();                                    
				for(User u : SiteUsers)
				{               
					Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
					msg.setWhatId(EmployerContact.ID);
					msg.setTargetObjectId(u.ID);
					msg.setSaveAsActivity(false);
					msg.setTemplateId(template.Id);
					msgs.add(msg);
				}            
				Messaging.sendEmail(msgs);
			}
        }

        JobSeeker = null;
    }
    
    @TestVisible
    private String getNextPage(String currPage)
    {
        if(String.isNotBlank(currPage) && currPage.isNumeric())
        {
            Integer pageNo = Integer.valueOf(currPage);
            return String.valueOf(pageNo + 1);
        }
        return null;
    }

    private void getNextEmployer(Boolean noPreviousEmployer)
    {
        String sensisId = getParameter('sensisId');
        EmployerContact = null;
        EmployerFollowUp = null;
        JobseekerFollowUp = null;
        SelectedBusiness = null;
        NextAddress = null;
        EmployerURL = null;
        for(Integer i = 0; i < SearchResults.size(); i++) 
        {
            if(SearchResults[i].id == sensisId || SearchResults[i].GooglePlacesID == sensisId)
            {    
                SelectedBusiness = SearchResults[i].Business;
				if(SearchResults[i].id == sensisId)
				{
					NextAddress = EncodingUtil.urlEncode(SearchResults[i].MapAddress, 'UTF-8');
					SelectedBusiness.Location__c = SearchResults[i].MapAddress;
					EmployerURL = SearchResults[i].WebSite;
					EmployerContact.Employer_Suburb__c = SearchResults[i].Suburb;
					EmployerContact.Address__c = SearchResults[i].Address;
					EmployerContact.Contact_Number__c = SearchResults[i].ContactNumber;
					SensisSearchController.sendViewReport(SearchResults[i].ReportingId, 
													UserInfo.getSessionId(), 
													SensisSearchController.getIpAddress());
				}
				else if(SearchResults[i].GooglePlacesID == sensisId)
				{
					GooglePlaces.getDetail(SelectedBusiness, EmployerContact);
					NextAddress = EncodingUtil.urlEncode(EmployerContact.Address__c, 'UTF-8');
					if(SelectedBusiness.Website__c == null)
					{
						EmployerURL = 'https://www.google.com.au/?q=' + SelectedBusiness.Name + ' ' + SelectedBusiness.Address__c + '&gws_rd=ssl#newwindow=1&safe=off&q=' + SelectedBusiness.Name;
						}
					else
					{
						EmployerURL = SelectedBusiness.Website__c;
					}
                    if(SelectedBusiness.State__c == null) {
                        SelectedBusiness.Location__c = SearchLocation;
                        SelectedBusiness.State__c = SearchState;
                    }
					upsert SelectedBusiness;
				}
				
                EmployerContact.Contacted_On__c = Datetime.now();
                break;
            }
        }
    }

    private void getBusinessDetails()
    {
        Set<String> sensisIds = new Set<String>();
		Set<String> googleIds = new Set<String>();
		Set<String> names = new Set<String>();
		Map<String, Business__c> businessesByName = new Map<String, Business__c>();
        for(SensisResponse.Results result : SearchResults)
        {          
            result.Name = result.Name.replace('\'', '');
            sensisIds.add(result.id);
			googleIds.add(result.GooglePlacesId);
			names.add(result.Name);
        }
        BusinessessBySensisID = null;
		List<Business__c> businessList;
		if(String.isBlank(EmployerLocationLatLong))
		{
			businessList = [SELECT  ID,
                                    Name,
                                    ABN__c,
                                    Last_Contacted__c,
                                    Do_Not_Disturb_Expiry__c,
                                    Sensis_ID__c,
									Google_Place_ID__c,
                                    Account__c,
                                    Account__r.Name,
                                    Last_Contacted_By__c,
                                    Last_Contacted_By__r.Name,
                                    Last_Result__c
                            FROM    Business__c
                            WHERE   Account__c = :CommunityAccount.ID AND 
									(
										(Sensis_ID__c IN :sensisIds AND 
										Sensis_ID__c != null)
									OR 
										(Google_Place_ID__c IN :googleIds AND 
										Google_Place_ID__c != null)
									OR 
										Name IN :names
									)];
		}
		else
		{
			String searchLat = EmployerLocationLatLong.substringBefore(',');
			String searchLong = EmployerLocationLatLong.substringAfter(',');
			businessList = [SELECT  ID,
                                    Name,
                                    ABN__c,
                                    Last_Contacted__c,
                                    Do_Not_Disturb_Expiry__c,
                                    Sensis_ID__c,
									Google_Place_ID__c,
                                    Account__c,
                                    Account__r.Name,
                                    Last_Contacted_By__c,
                                    Last_Contacted_By__r.Name,
                                    Last_Result__c
                            FROM    Business__c
                            WHERE   Account__c = :CommunityAccount.ID AND 
									(
										(Sensis_ID__c IN :sensisIds AND 
										Sensis_ID__c != null)
									OR 
										(Google_Place_ID__c IN :googleIds AND 
										Google_Place_ID__c != null)
									OR 
										(Name IN :names AND 
										DISTANCE(LatLong__c, GEOLOCATION(:Decimal.valueOf(searchLat), :Decimal.valueOf(searchLong)), 'km') < :Radius)
									)];
		}
		
        for(Business__c business : businessList)
        {
			String resultId = String.isBlank(business.Sensis_ID__c) ? business.Google_Place_ID__c : business.Sensis_ID__c;
			if(resultId != null)
			{
				BusinessessBySensisID.put(resultId, business);
			}
			businessesByName.put(business.Name, business);
        }
        for(SensisResponse.Results result : SearchResults)
        {
			String resultId = String.isBlank(result.id) ? result.GooglePlacesId : result.id;
            if(BusinessessBySensisID.containsKey(resultId))
            {
                Business__c business = BusinessessBySensisID.get(resultId);
                if(business.ABN__c == null)
                {
                    business.ABN__c = result.ABN;
                }
                result.Business = business;
            }
			else if(businessesByName.containsKey(result.Name))
			{
				Business__c business = businessesByName.get(result.Name);
				result.Business = business;
				result.id = String.isBlank(result.id) ? business.Sensis_ID__c : result.id;
				result.GooglePlacesId = String.isBlank(result.GooglePlacesId) ? business.Google_Place_ID__c : result.GooglePlacesId;
				BusinessessBySensisID.put(business.Sensis_ID__c, business);
			}
			else
			{
				if(result.PrimaryAddress == null || String.isBlank(result.PrimaryAddress.latitude) ||  String.isBlank(result.PrimaryAddress.latitude))
				{
					result.Business = new Business__c(Name = result.Name,
												Account__c = CommunityAccount.ID, 
												Sensis_ID__c = result.id,
												Google_Place_ID__c = result.GooglePlacesId,
												Location__c = result.MapAddress,
                                                ABN__c = result.ABN);
				}
				else
				{
					Decimal lat = String.isBlank(result.PrimaryAddress.latitude) ? null : Decimal.valueOf(result.PrimaryAddress.latitude);
					Decimal lng = String.isBlank(result.PrimaryAddress.latitude) ? null : Decimal.valueOf(result.PrimaryAddress.longitude);
					result.Business = new Business__c(Name = result.Name,
												Account__c = CommunityAccount.ID, 
												Sensis_ID__c = result.id,
												Google_Place_ID__c = result.GooglePlacesId,
												Location__c = result.MapAddress,
												Lat__c = lat,
												Long__c = lng,
                                                ABN__c = result.ABN);
				}
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
                                Job_Category3__c = :jobCategory OR
                                Job_Category4__c = :jobCategory OR
                                Job_Category5__c = :jobCategory OR
                                Job_Category6__c = :jobCategory OR
                                Job_Category7__c = :jobCategory OR
                                Job_Category8__c = :jobCategory
                        LIMIT 500];
        }
        
        if(String.isNotBlank(industryId))
        {
system.debug(industryId) ;
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
                                        Job_Category3__c  IN :jobCategoryIds OR
                                        Job_Category4__c  IN :jobCategoryIds OR
                                        Job_Category5__c  IN :jobCategoryIds OR
                                        Job_Category6__c  IN :jobCategoryIds OR
                                        Job_Category7__c  IN :jobCategoryIds OR
                                        Job_Category8__c  IN :jobCategoryIds)
                                    )]; 
        }
        for(Industry__c industry : industries)
        {
            categories += addCategoryID(industry.Sensis_Category_ID__c);
        }
        return categories;
    }

    private String addCategoryID(String categoryId)
    {
        return '&categoryId=' + categoryId;
    }

	private String getLocation(String resumeLocation)
	{
		if(CurrentUser.Marketing_Only__c)
		{
			if(String.isBlank(SearchLocation))
			{
				throw new BPException('Search Location is required');
			}
			return SearchLocation + ' ' + SearchState;
		}
		if(String.isNotBlank(resumeLocation))
		{
			return resumeLocation;
		}
        if(String.isBlank(EmployerLocation)) {
            return String.isBlank(SearchLocation) ? JobSeeker.Address_Location__c : SearchLocation;
        }
        return EmployerLocation;
	}
}