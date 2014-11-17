@isTest
public class TestJobSeekerExtension 
{
	private static testMethod void test1()
	{
		Job_Seeker__c js = insertJobSeeker();

		JobSeekerExtension ext = new JobSeekerExtension(new ApexPages.StandardController(js));

		system.assert(ext.EmployerContacts != null);
		system.assert(ext.FollowUps != null);

		system.assert(ext.checkAttributes() == null);
		system.assert(ext.commenceMarketing() == null);

		js.X1_Marketable_Attribute__c = 'test';
        js.X2_Marketable_Attribute__c = 'test';
        js.X3_Marketable_Attribute__c = 'test';
        update js;

		system.assert(ext.checkAttributes() != null);
		system.assert(ext.commenceMarketing() != null);

		ext.testErrorEnabled = true;
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
	}

	public static Job_Seeker__c insertJobSeeker()
	{
		Account a = new Account(Name = 'test');
		insert a;

		Job_Seeker__c js = new Job_Seeker__c();
		js.Account__c = a.ID;
		js.Name = 'test';
		js.JSK_ID__c = 'test';
		js.Suburb__c = 'Aldgate';
		js.State__c = 'SA';
		insert js;
		return js;
	}
}