@isTest
public class TestJobSeekerExtension 
{
	private static testMethod void test1()
	{
		Job_Seeker__c js = insertJobSeeker();

		JobSeekerExtension ext = new JobSeekerExtension(new ApexPages.StandardController(js));

		system.assert(ext.EmployerContacts != null);
		system.assert(ext.FollowUpsDone != null);
		system.assert(ext.FollowUpsToDo != null);
		system.assert(ext.Subsidies != null);
		system.assert(ext.SMSMessages != null);
		system.assert(ext.Subsidies != null);

		system.assert(ext.checkAttributes() == null);
		system.assert(ext.commenceMarketing() == null);

		js.X1_Marketable_Attribute__c = 'test';
        js.X2_Marketable_Attribute__c = 'test';
        js.X3_Marketable_Attribute__c = 'test';
        update js;

		system.assert(ext.checkAttributes() != null);
		system.assert(ext.commenceMarketing() != null);

		ext.checkBrokeredLiveUsername();
		ext.saveAndCommenceMarketing();
		ext.saveOverride();

		ext.testErrorEnabled = true;
		
	}

	private static testMethod void testErrors()
	{
		Job_Seeker__c js = insertJobSeeker();
		JobSeekerExtension ext = new JobSeekerExtension(new ApexPages.StandardController(js));
		try
		{
			ext.checkAttributes();
		}
		catch(Exception ex)
		{}
		try
		{
			ext.commenceMarketing();
		}
		catch(Exception ex)
		{}
		try
		{
			ext.saveOverride();
		}
		catch(Exception ex)
		{}
		try
		{
			ext.saveAndCommenceMarketing();
		}
		catch(Exception ex)
		{}
	}

	public static Job_Seeker__c insertJobSeeker()
	{
		Account a = new Account(Name = 'test', BrokeredLive__c = true, BrokeredLive_Per_EC__c = 5);
		insert a;

		Job_Seeker__c js = new Job_Seeker__c();
		js.Assigned_To__c = UserInfo.getUserId();
		js.Account__c = a.ID;
		js.Name = 'test';
		js.Suburb__c = 'Aldgate';
		js.State__c = 'SA';
		js.BrokeredLive__c = true;
		js.BrokeredLive_Username__c = 'testtest';
		js.BrokeredLive_Phrase__c = 'testtest';
		js.BrokeredLive_Phrase_Prompt__c = 'test';
		insert js;
		return js;
	}

	public static Employer_Contact__c insertEmployerContact(Job_Seeker__c js)
	{
		Business__c b = new Business__c(Name = 'test', Sensis_ID__c = '1234');
		b.Account__c = js.Account__c;
		insert b;

		Employer_Contact__c ec = new Employer_Contact__c(Job_Seeker__c = js.ID);
		ec.Result__c = BPConstants.EmployerContact_Result_LeftMessage;
		ec.User__c = js.Assigned_To__c;
		ec.Business__c = b.ID;
		ec.Contacted_On__c = Date.today();
		insert ec;
		return ec;
	}

	public static Follow_Up__c insertFollowup(Employer_Contact__c ec)
	{
		Follow_Up__c fu = new Follow_Up__c();
		fu.Job_Seeker__c = ec.Job_Seeker__c;
		fu.Employer_Contact__c = ec.ID;
		fu.Type__c = BPConstants.FollowUp_Type_CallEmployer;
		fu.Assigned_To__c = ec.User__c;
		insert fu;
		return fu;
	}
}