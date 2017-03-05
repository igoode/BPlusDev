public with sharing class BPEmployerExtension 
	extends BPPageBase
{
    public BPEmployerExtension(ApexPages.StandardController ctrlr)
    {
        if(!Test.isRunningTest())
        {
            ctrlr.addFields(new String[]{'Account__c','Sensis_ID__c','Google_Place_ID__c'});
        }
    	controller = ctrlr;
		Business__c business = (Business__c)controller.getRecord();
		ListingChecked = business.Sensis_ID__c != null || business.Google_Place_ID__c != null;
		if(business.Location__c != null)
		{
			String[] locParts = business.Location__c.split(',');
			if(locParts.size() == 2) 
			{
				SearchLocation = locParts[0];
				SearchState = locParts[1];
			}
		}
    }

    private ApexPages.StandardController controller;

	public Boolean ListingChecked
    {
        get;
        set;
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

    public String ReferralTo
    {
        get;
        set;
    }

    public List<SelectOption> PlacementOptions 
    {
        get
        {
            if(PlacementOptions == null)
            {
                PlacementOptions = new List<SelectOption>();
                for(Account a : [SELECT  ID,
                                        Employer_Contact_Results__c
                                FROM    Account 
                                WHERE   ID = :CurrentUser.AccountID AND 
                                        Employer_Contact_Results__c != null])
                {
                    for(String s : a.Employer_Contact_Results__c.split(';'))
                    {
                        PlacementOptions.add(new SelectOption(s, s));
                    }
                }
            }
            return PlacementOptions;
        }
        set;
    }

    public Contact NewContact
    {
        get
        {
            if(NewContact == null)
            {
                NewContact = new Contact(Business__c = controller.getId());
            }
            return NewContact;
        }
        set;
    }

    public List<Employer_Contact__c> EmployerContacts 
    {
        get
        {
                if(EmployerContacts == null)
                {
                    EmployerContacts = [SELECT Id, 
                                                Name,                                              
                                                Category__c, 
                                                Contact_Email__c, 
                                                Contact_Number__c, 
                                                Contact_Person__c, 
                                                Contact_Position__c, 
                                                Contacted_On__c, 
                                                Hours__c, 
                                                Comment__c,
                                                Interview_Date__c, 
                                                Interview_Time__c, 
                                                Job_Details__c, 
                                                Job_Title__c, 
                                                Result__c, 
                                                Sensis_ID__c, 
                                                User__c,
                                                User__r.Name,
                                                Job_Seeker__c,
                                                Job_Seeker__r.Name,
                                                Business__c, 
                                                Business__r.Name,
                                                Signups__c,
                                                Signups_Complete_Count__c,
                                                Signups_Incomplete__c
                                        FROM    Employer_Contact__c
                                        WHERE   Business__c = :controller.getId() AND 
                                                Live_Session__c = null AND
                                                Referral_From__c = null
                                        ORDER BY Contacted_On__c DESC]; 
                }
                return EmployerContacts;
        }
        private set;
    }

    public List<Contact> Contacts
    {
        get
        {
            if(Contacts == null)
            {
                Contacts = [SELECT Id,
                                    Name,
                                    Email,
                                    Phone,
                                    MobilePhone,
                                    MailingAddress,
                                    OtherAddress,
                                    Description,
                                    CreatedBy.Name,
                                    LastModifiedDate
                            FROM    Contact
                            WHERE   Business__c = :controller.getId()
                            ORDER BY Name];
            }
            return Contacts;
        }
        private set;
    }

    public List<Follow_Up__c> Followups 
    {
        get
        {
                if(Followups == null)
                {
                    Followups = [SELECT Id, 
                                        Name,
                                        Employer_Contact__c, 
                                        Action_Taken__c,
                                        Actioned__c, 
                                        Address_Confirmed__c, 
                                        Contact_Number__c, 
                                        Due_Date__c, 
                                        Due_Time__c,
                                        Email__c,
                                        No_Further_Action_Required__c,
                                        Employer_Contact_Person__c, 
                                        Employer_Contact_Position__c,                                               
                                        Interview_Date__c, 
                                        Result__c, 
                                        Interview_Time__c, 
                                        Job_Seeker__c,  
                                        Type__c,
                                        Comment__c,
										Open_Vacancy__c,
                                        Job_Seeker__r.Name,
                                        Employer__c,
                                        Employer_Contact__r.Contact_Number__c,
                                        Employer_Contact__r.Business__r.Name,
                                        Job_Seeker__r.Assigned_To__r.Name,
                                        Assigned_To__c, 
                                        Assigned_To__r.Name       
                                FROM    Follow_Up__c
                                WHERE   RecordTypeID = :BPConstants.FollowUp_RecordType_Followup_ID AND
                                        Employer_Contact__r.Business__c = :controller.getId()
                                ORDER BY CreatedDate DESC];
                }
                return Followups;
        }
        private set;
    }

    public List<Communication__c> Subsidies 
    {
        get
        {
                if(Subsidies == null)
                {
                    Subsidies = [SELECT Id, 
                                        CreatedDate,
                                        EC__r.Name,
                                        Job_Seeker__c,
                                        Sent__c,
                                        (SELECT ID 
                                        FROM    Attachments)
                                FROM    Communication__c
                                WHERE   Employer__c = :controller.getId() AND 
                                        RecordType.Name = :BPConstants.Communication_RecordType_WageSubsidy];
                }
                return Subsidies;
        }
        private set;
    }

    public List<Communication__c> Emails 
    {
        get
        {
                if(Emails == null)
                {
                    Emails = [SELECT Id, 
                                        CreatedDate,
                                        EC__r.Name,
                                        Job_Seeker__c,
                                        Message__c,
                                        Sent__c,
                                        Type__c
                                FROM    Communication__c
                                WHERE   Employer__c = :controller.getId() AND 
                                        RecordType.Name = :BPConstants.Communication_RecordType_Email
                                ORDER BY Sent__c DESC];
                }
                return Emails;
        }
        private set;
    }

    public static void createSignupFollowup(Employer_Contact__c signup)
    {
        if(signup.Signups_Complete__c > 0)
        {
            Follow_Up__c signupFollowup = new Follow_Up__c(RecordTypeID = BPConstants.FollowUp_RecordType_SignupComplete_ID,
                    Employer_Contact__c = signup.ID,
                    Complete__c = signup.Signups_Complete__c,
                    Completed_Date__c = Date.today());
            insert signupFollowup;
        }
    }

    public static Employer_Contact__c createReferral(Employer_Contact__c employerContact, ID referralTo)
    {
        Employer_Contact__c signup = employerContact.clone(false, true);
        signup.Result__c = BPConstants.EmployerContact_Result_Signup;
        signup.Referral_From__c = employerContact.ID;
        signup.User__c = referralTo;
        insert signup;

        employerContact.Referral_To__c = signup.ID;
        update employerContact;

        createSignupFollowup(signup);

        User currUser = (new BPPageBase()).CurrentUser;

        for(User u : [SELECT Name,
                            User_Email__c
                        FROM User
                        WHERE ID = :signup.User__c]) {
            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
            msg.setSubject('A referral has been assigned to you');
            msg.setToAddresses(new String[]{u.User_Email__c});
            String body = currUser.Name + ' has created a referral with ' + String.valueOf(signup.Signups__c) + ' signups for you.';
            body += '<br/>You can view the record here: https://brokeredplus.force.com/bplus/' + signup.ID;
            msg.setHtmlBody(body);
            BPEmailFactory.addUserHtmlSignature(msg, currUser);

            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{
                    msg
            });
        }
        return signup;
    }

    public PageReference newContact()
    {
    	try
    	{
    		throwTestError();
            upsert NewContact;

    		PageReference pg = Page.BPEmployer;
    		pg.getParameters().put('id', controller.getID());
    		return pg.setRedirect(true);
    	}
		catch(Exception ex)
		{
			return addMessage(ex);
		}
    }

    public PageReference newEmployerContact()
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

    public PageReference saveOverride()
    {
    	try
    	{
    		throwTestError();
            Business__c business = (Business__c)controller.getRecord();
            Boolean valid = true;
            valid = isRequiredFieldValid(business.Name, 'Business Name', valid);
            if(business.Location__c == null && String.isNotBlank(SearchLocation))
            {
                business.Location__c = SearchLocation;
            }
            if(business.State__c == null && String.isNotBlank(SearchState))
            {
                business.State__c = SearchState;
            }
            valid = isRequiredFieldValid(business.Location__c, 'Location', valid);
            if(!valid)
            {
                return null;
            }
			/*if(checkExists(business))
			{
				addMessage('This business already exists, try searching for it from the home page'); 
				return null;	
			}*/
            if(checkABNExists(business))
            {
                addMessage('An employer with this ABN already exists, either check the ABN or use it to search for the employer from the home page');
                return null;
            }
            if(String.isBlank(business.Account__c))
            {
                business.Account__c = CurrentUser.AccountID;
            }
            upsert business;
    		PageReference pg = Page.BPEmployer;
    		pg.getParameters().put('id', business.ID);
    		return pg.setRedirect(true);
    	}
		catch(Exception ex)
		{
			return addMessage(ex);
		}
    }

	public void checkListing()
	{
		Business__c business = (Business__c)controller.getRecord();
        if(String.isBlank(business.Name))
        {
            addMessage('Name is required');
        }
        if(String.isBlank(SearchLocation) ||  String.isBlank(SearchState))
        {
            addMessage('Location is required');
        }
        if(ApexPages.hasMessages())
        {
            return;
        }
		business.Location__c = SearchLocation + ',' + SearchState;
		Location loc = GooglePlaces.getLocation(business.Location__c);
		if(loc == null) 
		{
			addMessage('Location could not be determined'); 
			return; 
		}

		String latLong = String.valueOf(loc.getLatitude()) + ',' + String.valueOf(loc.getLongitude());
		if(String.isBlank(business.Google_Place_ID__c))
		{
			GooglePlacesJSON placesJSON = GooglePlaces.search(business.Name, '1', business.Location__c, latLong, null);
			if(!Test.isRunningTest()) 
			{
				for(GooglePlacesJSON.Results result : placesJSON.results)
				{
					if(result.Name == business.Name)
					{ 
						business.Google_Place_ID__c = result.place_id;
						break;
					}
				}
			}
		}
		if(String.isBlank(business.Sensis_ID__c))
		{
			for(SensisResponse.Results result : (new SensisSearchController()).doSearchByQuery(business.Name, business.Location__c, '5', '1'))
			{
				if(result.Name == business.Name)
				{
					business.Sensis_ID__c = result.id;
					break;
				}
			}
		}
        
		if(checkExists(business))
		{
			addMessage('This business already exists, try searching for it from the home page'); 
			ListingChecked = false;
			return;	
		}
        if(String.isBlank(business.Sensis_ID__c) && String.isBlank(business.Google_Place_ID__c))
		{
			addMessage(ApexPages.Severity.WARNING, 'The online listing for this business could not be found, it can still be saved however it will not appear in any marketing searches and its last contacted date will not be known.'); 
		}
		else 
		{
			addMessage(ApexPages.Severity.INFO, 'Online listing found.'); 
		}
		ListingChecked = true;
	}

	private Boolean checkExists(Business__c business)
	{
		for(Business__c b : [SELECT	ID 
							FROM	Business__c 
							WHERE	ID != :business.ID AND
									(
										(Sensis_ID__c = :business.Sensis_ID__c AND 
										Sensis_ID__c != null) 
										OR 
										(Google_Place_ID__c = :business.Google_Place_ID__c AND 
										Google_Place_ID__c != null)
									)])
		{
			return true;	
		}
		return false;
	}

    private Boolean checkABNExists(Business__c business)
    {
        if(String.isBlank(business.ABN__c))
        {
            return false;
        }
        business.ABN__c = business.ABN__c.deleteWhitespace();
        for(Business__c b : [SELECT	ID
                            FROM	Business__c
                            WHERE	ID != :business.ID AND
                                    ABN__c = :business.ABN__c])
        {
            return true;
        }
        return false;
    }
}