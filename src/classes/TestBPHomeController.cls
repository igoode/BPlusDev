@isTest
private class TestBPHomeController 
{
	private static testMethod void test1()
	{
		Job_Seeker__c js = TestJobSeekerExtension.insertJobSeeker();
		TestJobSeekerExtension.insertEmployerContact(js);
		BPHomeController ext = new BPHomeController();

		system.assert(ext.MyJobSeekers != null);
		system.assert(ext.MyFollowUps != null);
		system.assert(ext.MyEmployerContacts != null);

		system.assert(ext.JobSeekerSearchResults != null);
		ext.JobSeekerSearch = js.Name;
		ext.searchJS();

		ext.JobSeekerSearch = 'test';
		ext.searchJS();

		system.assert(ext.JobSeekerSearchResults != null);
		system.assert(ext.EmployerSearchResults != null); 
		
		ext.checkCredentials();

		ext.AttributeSearch = 'test';
		ext.AttributeSearch2 = 'test';
		System.debug(ext.Attributes);
		ext.searchAttr();

	}
}