/**
 * An apex class that keeps updates of a portal user in sync with its corresponding contact.
   Guest users are never able to access this page.
 */
public with sharing class MyProfilePageController extends BPPageBase {

    private User user;
    private boolean isEdit = false;
    private transient Blob tNewBio;

    public User getUser() {
        return user;
    }

    public Blob NewBio
    {
        get
        {
            return tNewBio;
        }

        set
        {
            tNewBio = value;
        }
    }

    public String BioName
    {
        get;
        set;
    }

    public String BioContentType
    {
        get;
        set;
    }

    public MyProfilePageController() {
        user = [SELECT id, email, username, usertype, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                street, city, country, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email
                FROM User
                WHERE id = :UserInfo.getUserId()];
        // guest users should never be able to access this page
        if (user.usertype == 'GUEST') {
            throw new NoAccessException();
        }
        if(ApexPages.currentPage() != null)
        {
            ApexPages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=Edge');
        }
    }

    public Boolean getIsEdit() {
        return isEdit;
    }

    public void edit() {
        isEdit=true;
    }

    public void save() {
        if (user.contact != null) {
            setContactFields(user.contact, user);
        }

        try {
            update user;
            if (user.contact != null) {
                update user.contact;
            }
            isEdit=false;
        } catch(DmlException e) {
            ApexPages.addMessages(e);
        }
    }

    public PageReference changePassword() {
        return Page.ChangePassword;
    }

    public PageReference uploadBio()
    {
        Savepoint sp = Database.setSavepoint();
        try {
            if (BioName == null) {
                addMessage('No file is selected');
                return null;
            }

            if(UserBio.ID != null)
            {
                DMLAsSystem.deleteSObject(UserBio);
            }

            Attachment a = new Attachment();
            a.Name = BioName;
            a.Body = NewBio;
            a.ParentId = CurrentUser.ContactId;
            a.Description = 'Bio';
            a.ContentType = BioContentType;
            DMLAsSystem.insertsObject(a);
            return Page.MyProfilePage;
        }
        catch (Exception e)
        {
            return addMessage(e, sp);
        }
    }

    public void cancel() {
        isEdit=false;
        user = [SELECT id, email, username, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                street, city, country, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email
                FROM User
                WHERE id = :UserInfo.getUserId()];
    }

    public static void setContactFields(Contact c, User u) {
        c.title = u.title;
        c.firstname = u.firstname;
        c.lastname = u.lastname;
        c.email = u.email;
        c.phone = u.phone;
        c.mobilephone = u.mobilephone;
        c.fax = u.fax;
        c.mailingstreet = u.street;
        c.mailingcity = u.city;
        c.mailingstate = u.state;
        c.mailingpostalcode = u.postalcode;
        c.mailingcountry = u.country;
    }
}