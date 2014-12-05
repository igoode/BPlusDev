@isTest
private class TestBPFollowupExtension 
{
	private static testMethod void test1()
	{
		Job_Seeker__c js = TestJobSeekerExtension.insertJobSeeker();

		Follow_Up__c fu = new Follow_Up__c();
		fu.Job_Seeker__c = js.ID;
		fu.Employer_Contact__c = TestJobSeekerExtension.insertEmployerContact(js).ID;
		fu.Action_Taken__c = BPConstants.EmployerContact_Result_LeftMessage;
		insert fu;

		BPFollowupExtension ext = new BPFollowupExtension(new ApexPages.StandardController(fu));
		ext.saveOverride();

		ext.sendEmployerDetails();

		BPFollowupExtension.sendSMS(js, 'test', 'test');

		
		
	}

	private static testMethod void test2()
	{
		Job_Seeker__c js = TestJobSeekerExtension.insertJobSeeker();

		Follow_Up__c fu = new Follow_Up__c();
		fu.Job_Seeker__c = js.ID;
		fu.Employer_Contact__c = TestJobSeekerExtension.insertEmployerContact(js).ID;
		fu.Action_Taken__c = BPConstants.EmployerContact_Result_LeftMessage;
		insert fu;

		BPFollowupExtension ext = new BPFollowupExtension(new ApexPages.StandardController(fu));
		ext.testErrorEnabled = true;
		try
		{
			ext.saveOverride();
		}
		catch (Exception ex)
		{}
		try
		{
			ext.sendEmployerDetails();
		}
		catch (Exception ex)
		{}
	}
}