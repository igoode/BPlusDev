@isTest
private class TestBPFollowupExtension 
{
	private static testMethod void test1()
	{
		Job_Seeker__c js = TestJobSeekerExtension.insertJobSeeker();

		Follow_Up__c fu = new Follow_Up__c();
		fu.Job_Seeker__c = js.ID;
		fu.Employer_Contact__c = TestJobSeekerExtension.insertEmployerContact(js).ID;

		insert fu;

		BPFollowupExtension ext = new BPFollowupExtension(new ApexPages.StandardController(fu));
		ext.saveOverride();

		try
		{
			ext.testErrorEnabled = true;
			ext.saveOverride();
		}
		catch (Exception ex)
		{}
	}


}