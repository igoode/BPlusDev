public with sharing class BPWorksheetController extends BPPageBase
{
    public BPWorksheetController()
    {
        for(User u : [SELECT ID,
                            Contact.Name,
                            Contact.Account.Sites__c
                    FROM    User
                    WHERE 	ID = :UserInfo.getUserId()])
        {
            if(u.Contact.Account.Sites__c != null)
            {
                for(String s : u.Contact.Account.Sites__c.split(';'))
                {
                    if(s == u.Contact.Name)
                    {
                        SelectedSite = u.Contact.Name;
                    }
                }
            }
        }
    }
    private Set<String> marketingResults = new Set<String>{'Interview', 'Resume sent / apply online' };
    private transient List<SelectOption> tEmployerList;

    public String SelectedSite
    {
        get;
        set;
    }

    public String ActionedContactId
    {
        get;set;
    }

    public String SelectedJobSeeker
    {
        get;
        set
        {
            if(value != SelectedJobSeeker)
            {
                SelectedJobSeekerName = null;
                for(Job_Seeker__c js : [SELECT Name
                                        FROM    Job_Seeker__c
                                        WHERE   ID = :value])
                {
                    SelectedJobSeekerName = js.Name;
                }
            }
            SelectedJobSeeker = value;
        }
    }

    public String SelectedEmployerID
    {
        get;
        set
        {
            if(value != SelectedEmployerID)
            {
                SelectedEmployer = new Business__c();
                for(Business__c bus : [SELECT  Name,
                                                Phone__c,
                                                (SELECT Contact_Number__c
                                                FROM    Employer_Contacts__r
                                                WHERE   Contact_Number__c != null
                                                ORDER BY Contacted_On__c DESC
                                                LIMIT 1)
                                        FROM    Business__c
                                        WHERE   ID = :value])
                {
                    SelectedEmployer = bus;
                    if(SelectedEmployer.Phone__c == null && bus.Employer_Contacts__r != null)
                    {
                        for(Employer_Contact__c ec : bus.Employer_Contacts__r)
                        {
                            SelectedEmployer.Phone__c = ec.Contact_Number__c;
                        }
                    }
                }
            }
            SelectedEmployerID = value;
        }
    }

    public String SelectedJobSeekerName
    {
        get;set;
    }

    public Business__c SelectedEmployer
    {
        get;
        set;
    }

    public Employer_Contact__c NewContact
    {
        get
        {
            if(NewContact == null)
            {
                NewContact = new Employer_Contact__c();
            }
            return NewContact;
        }
        set;
    }

    public List<EmployerWrapper> Employers
    {
        get
        {
            if(Employers == null)
            {
                Employers = new List<EmployerWrapper>();
                for(Business__c b :[SELECT ID,
                                            Name,
                                            Phone__c,
                                            (SELECT  Contacted_On__c,
                                                    Activity_Result_Display__c,
                                                    Contact_Number__c,
                                                    CreatedBy.Name,
                                                    Job_Seeker__r.Name,
                                                    Flagged_For__r.Name,
                                                    Flagged_Colour__c,
                                                    Flagged_Actioned__c,
                                                    Comment__c
                                            FROM    Employer_Contacts__r
                                            ORDER BY Contacted_On__c DESC
                                            LIMIT 1)
                                    FROM    Business__c
                                    WHERE   ID IN (SELECT   Business__c
                                                    FROM    Employer_Contact__c
                                                    WHERE   Job_Seeker__r.Site__c = :SelectedSite AND
                                                            (Activity_Result__c != null OR
                                                            Show_as_activity__c = true))
                            ORDER BY Name])
                {
                    Employers.add(new EmployerWrapper(b));
                }
            }
            return Employers;
        }
        set;
    }

    public List<JobSeekerWrapper> JobSeekers
    {
        get
        {
            if(JobSeekers == null)
            {
                JobSeekers = new List<JobSeekerWrapper>();
                for(Job_Seeker__c js : getJobSeekers(SelectedSite))
                {
                    JobSeekers.add(new JobSeekerWrapper(js));
                }
            }
            return JobSeekers;
        }
        set;
    }

    public List<SelectOption> JobSeekerList
    {
        get
        {
            if(JobSeekerList == null)
            {
                JobSeekerList = new List<SelectOption>{new SelectOption('', '--None--')};
                for(Job_Seeker__c js : getJobSeekers(SelectedSite))
                {
                    JobSeekerList.add(new SelectOption(js.ID, js.Name));
                }
            }
            return JobSeekerList;
        }
        set;
    }

    public List<SelectOption> EmployerList
    {
        get
        {
            if(tEmployerList == null)
            {
                tEmployerList = new List<SelectOption>{new SelectOption('', '--None--')};
                for(Business__c b : [SELECT ID,
                                            Name
                                    FROM    Business__c
                                    WHERE   ID IN (SELECT   Business__c
                                                    FROM    Employer_Contact__c
                                                    WHERE   Job_Seeker__r.Site__c = :SelectedSite)
                                    ORDER BY Name])
                {
                    tEmployerList.add(new SelectOption(b.ID, b.Name));
                }
            }
            return tEmployerList;
        }
    }

    public List<Employer_Contact__c> JobSeekerContacts
    {
        get
        {
            if(JobSeekerContacts == null)
            {
                JobSeekerContacts = [SELECT ID,
                                            Business__c,
                                            Contacted_On__c,
                                            Business__r.Name,
                                            Comment__c,
                                            Activity_Result_Display__c,
                                            Business__r.Phone__c,
                                            Contact_Number__c,
                                            Contact_Person__c,
                                            Contact_Position__c,
                                            Flagged_For__c,
                                            Flagged_For__r.Name,
                                            Flagged_Colour__c,
                                            Flagged_Actioned__c
                                    FROM    Employer_Contact__c
                                    WHERE   Job_Seeker__c = :SelectedJobSeeker AND
                                            (Activity_Result__c != null OR
                                            Show_as_activity__c = true)
                                    ORDER BY Contacted_On__c DESC];
            }
            return JobSeekerContacts;
        }
        set;
    }

    public List<Employer_Contact__c> EmployerContacts
    {
        get
        {
            if(EmployerContacts == null)
            {
                EmployerContacts = [SELECT ID,
                                            Business__c,
                                            Contacted_On__c,
                                            Business__r.Name,
                                            Comment__c,
                                            Activity_Result_Display__c,
                                            Job_Seeker__c,
                                            Job_Seeker__r.Name,
                                            Business__r.Phone__c,
                                            Contact_Number__c,
                                            Contact_Person__c,
                                            Contact_Position__c,
                                            Flagged_For__c,
                                            Flagged_For__r.Name,
                                            Flagged_Colour__c,
                                            Flagged_Actioned__c
                                    FROM    Employer_Contact__c
                                    WHERE   Business__c = :SelectedEmployerID AND
                                            (Activity_Result__c != null OR
                                            Show_as_activity__c = true)
                                    ORDER BY Contacted_On__c DESC];
            }
            return EmployerContacts;
        }
        set;
    }

    public void getJobseeker()
    {
        JobSeekerContacts = null;
        NewContact = null;
    }

    public void getEmployer()
    {
        EmployerContacts = null;
        NewContact = null;
    }

    public void refreshSite()
    {
        JobSeekers = null;
        JobSeekerList = null;
        tEmployerList = null;
        Employers = null;
        NewContact = null;
        EmployerContacts = null;
        JobSeekerContacts = null;
    }

    public void newEmpContact()
    {
        if(NewContact.Business__c == null)
        {
            NewContact.Business__c = SelectedEmployer.Id;
            NewContact.Contact_Number__c = SelectedEmployer.Phone__c;
        }
        saveContact(NewContact);
    }

    public void newJSContact()
    {
        if(NewContact.Job_Seeker__c == null)
        {
            NewContact.Job_Seeker__c = SelectedJobSeeker;
        }
        saveContact(NewContact);
    }

    public void actioned()
    {
        try
        {
            Employer_Contact__c ec = new Employer_Contact__c(ID = ActionedContactId);
            ec.Flagged_Actioned__c = Datetime.now();
            update ec;

            refreshSite();
        }
        catch(Exception ex)
        {
            addMessage(ex);
        }
    }

    private void saveContact(Employer_Contact__c ec)
    {
        if(ec.Job_Seeker__c == null)
        {
            addMessage('Jobseeker is required.');
        }
        if(ec.Business__c == null)
        {
            addMessage('Employer is required.');
        }
        if(ec.Activity_Result__c == null)
        {
            addMessage('Result is required.');
        }
        if(ApexPages.hasMessages())
        {
            return;
        }
        if(ec.Contacted_On__c == null)
        {
            ec.Contacted_On__c = Datetime.now();
        }
        ec.User__c = CurrentUser.ID;
        if(ec.Contact_Number__c == null)
        {
            for(Business__c e : [SELECT ID,
                                        Phone__c,
                                        (SELECT Contact_Number__c
                                        FROM    Employer_Contacts__r
                                        WHERE   Contact_Number__c != null
                                        ORDER BY Contacted_On__c DESC
                                        LIMIT 1)
                            FROM    Business__c
                            WHERE   ID = :ec.Business__c])
            {
                if(e.Phone__c != null)
                {
                    ec.Contact_Number__c = e.Phone__c;
                }
                else
                {
                    for(Employer_Contact__c con: e.Employer_Contacts__r)
                    {
                        ec.Contact_Number__c = con.Contact_Number__c;
                    }
                }
            }
        }
        upsert NewContact;
        EmployerContacts = null;
        JobSeekerContacts = null;
        NewContact = null;
    }

    private List<Job_Seeker__c> getJobSeekers(String site)
    {
        return [SELECT  ID,
                        Name,
                        Site__c,
                        (SELECT ID,
                                Business__c,
                                Contacted_On__c,
                                Comment__c,
                                Business__r.Name,
                                Business__r.Phone__c,
                                Contact_Number__c,
                                Contact_Person__c,
                                Contact_Position__c,
                                Activity_Result_Display__c,
                                Flagged_For__c,
                                Flagged_For__r.Name,
                                Flagged_Colour__c,
                                Flagged_Actioned__c
                        FROM    Employer_Contacts__r
                        WHERE   (Activity_Result__c != null OR
                                Show_as_activity__c = true)
                        ORDER BY Contacted_On__c DESC
                        LIMIT 1)
                    FROM    Job_Seeker__c
                    WHERE   Site__c = :site AND
                            Site__c != null
                            ORDER BY Name];
    }

    public class EmployerWrapper
    {
        public EmployerWrapper(Business__c b)
        {
            LastEmployerContact = new Employer_Contact__c();
            Employer = b;
            for(Employer_Contact__c ec : b.Employer_Contacts__r)
            {
                LastEmployerContact = ec;
                if(Employer.Phone__c == null)
                {
                    if(ec.Contact_Number__c != null)
                    {
                        Employer.Phone__c = ec.Contact_Number__c;
                        break;
                    }
                }
            }
        }

        public Business__c Employer
        {
            get;set;
        }

        public Employer_Contact__c LastEmployerContact
        {
            get;set;
        }
    }

    public class JobSeekerWrapper
    {
        public JobSeekerWrapper(Job_Seeker__c js)
        {
            LastJobSeekerContact = new Employer_Contact__c();
            Jobseeker = js;
            for(Employer_Contact__c ec : js.Employer_Contacts__r)
            {
                LastJobSeekerContact = ec;
                break;
            }
        }

        public Job_Seeker__c Jobseeker
        {
            get;set;
        }

        public Employer_Contact__c LastJobSeekerContact
        {
            get;set;
        }
    }
}