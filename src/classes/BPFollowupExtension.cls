public class BPFollowupExtension 
	extends BPPageBase
{
    public BPFollowupExtension(ApexPages.StandardController ctrlr)
    {
        if(!Test.isRunningTest())
        {
            ctrlr.addFields(new String[]{'Employer_Contact__c','Job_Seeker__c','Job_Seeker__r.Mobile__c'});
        }
    	controller = ctrlr;
    }

    private ApexPages.StandardController controller;
    
    public Employer_Contact__c NextContact
    {
        get 
        {
            if(NextContact == null)
            {
                Follow_Up__c fu = (Follow_Up__c)controller.getRecord();
                NextContact = getEmployerContact(fu.Employer_Contact__c);
            }
            return NextContact;
        }
        set;
    }
    public void saveOverride()
    {
        Savepoint sp = Database.setSavepoint();
    	try
    	{
            throwTestError();
			Follow_Up__c fu = (Follow_Up__c)controller.getRecord();
            if(!fu.No_Further_Action_Required__c &&
                    !isRequiredFieldValid(fu.Action_Taken__c, 'Action Taken', true))
            {
                return;
            }
    		if(fu.Actioned__c == null)
    		{
    			fu.Actioned__c = Datetime.now();
    		}
    		update fu;
            if(!fu.No_Further_Action_Required__c &&
                    (fu.Action_Taken__c == BPConstants.EmployerContact_Result_ResumeDropOff ||
                    fu.Action_Taken__c == BPConstants.EmployerContact_Result_Interview ||
                    fu.Action_Taken__c == BPConstants.EmployerContact_Result_ResumeSent ||
                    fu.Action_Taken__c == BPConstants.EmployerContact_Result_LeftMessage ||
                    fu.Action_Taken__c == BPConstants.EmployerContact_NoAnswer))
            {             
                // create a new Employer Contact record for this action
                Employer_Contact__c follwupEc = new Employer_Contact__c(Job_Seeker__c = fu.Job_Seeker__c);
                follwupEc.Contacted_On__c = DateTime.now();
                follwupEc.Result__c = fu.Action_Taken__c;
                follwupEc.User__c = NextContact.User__c;
                follwupEc.Business__c = NextContact.Business__c;
                follwupEc.Contact_Email__c = NextContact.Contact_Email__c;
                follwupEc.Contact_Number__c = NextContact.Contact_Number__c;
                follwupEc.Contact_Person__c = NextContact.Contact_Person__c;
                follwupEc.Contact_Position__c = NextContact.Contact_Position__c;
                follwupEc.Employer_Suburb__c = NextContact.Employer_Suburb__c;
                follwupEc.Interview_Date__c = NextContact.Interview_Date__c;
                follwupEc.Interview_Time__c = NextContact.Interview_Time__c;
                follwupEc.Address__c = NextContact.Address__c;
                insert follwupEc;
                fu.Followup_Employer_Contact__c = follwupEc.ID;
                update fu;
            }
    	}
        catch(Exception ex)
        {
            addMessage(ex, sp);
        }
    }

    public void sendEmployerDetails()
    {
        try
        {
            throwTestError();
            Follow_Up__c fu = (Follow_Up__c)controller.getRecord();
            Employer_Contact__c ec = getEmployerContact(fu.Followup_Employer_Contact__c == null ? fu.Employer_Contact__c : fu.Followup_Employer_Contact__c);
            Job_Seeker__c jobSeeker = new Job_Seeker__c(ID = fu.Job_Seeker__c, Mobile__c = fu.Job_Seeker__r.Mobile__c);
            String message = CurrentUser.Contact.Account.Name + ' has arranged for you to meet an employer at ' + 
                        ec.Address__c +
                        ' on ' + ec.Interview_Date__c.format() + 
                        ' at ' + ec.Interview_Time__c + 
                        '. Please notify us if you are unable to attend.';

            SMS_Notification__c notification = sendSMS(jobSeeker, message, ec.Result__c) ;
            insert notification;                     
            addMessage(ApexPages.Severity.INFO, 'SMS sent.');
        }
        catch(Exception ex)
        {
            addMessage(ex);
        }
    }

    public static SMS_Notification__c sendSMS(Job_Seeker__c jobSeeker, String message, String type)
    {
        String phNumber = BPSMSUtilities.cleanPhoneNumber(jobSeeker.Mobile__c);
        String smsReference = BPSMSUtilities.sendSMS(message, phNumber, null); 
        SMS_Notification__c notification = new SMS_Notification__c(Job_Seeker__c = jobSeeker.ID,
                                                Number__c = phNumber,
                                                Message__c = message,
                                                Type__c = type);
        if(smsReference != null)
        {
            notification.Sent__c = Datetime.now();
            notification.Gateway_Reference__c = smsReference;
            
        }
        return notification;
    }


    private Employer_Contact__c getEmployerContact(ID ecID)
    {
        return [SELECT Id, 
                        Name,                                                                                       
                        Category__c, 
                        Contact_Email__c, 
                        Contact_Number__c, 
                        Contact_Person__c, 
                        Contact_Position__c,  
                        Hours__c,  
                        Job_Details__c, 
                        Job_Title__c, 
                        Interview_Date__c,
                        Interview_Time__c,
                        Result__c, 
                        User__c,
                        Job_Seeker__c,
                        Address__c,
                        Business__c,
                        Employer_Suburb__c 
                FROM    Employer_Contact__c
                WHERE   ID = :ecID];
    }
}