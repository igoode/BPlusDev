@isTest
private class TestBPEmployerExtension 
{
	private static testMethod void test1()
	{
		Job_Seeker__c js = TestJobSeekerExtension.insertJobSeeker();
		Employer_Contact__c ec = TestJobSeekerExtension.insertEmployerContact(js);
		Follow_Up__c fu = TestJobSeekerExtension.insertFollowup(ec);
		Business__c b = [SELECT ID FROM Business__c WHERE ID = :ec.Business__c];

		BPEmployerExtension ext = new BPEmployerExtension(new ApexPages.StandardController(b));

		system.assert(ext.EmployerContacts != null);
		system.assert(ext.Followups != null);
		system.assert(ext.Subsidies != null);

		ext.newContact();
	}
}