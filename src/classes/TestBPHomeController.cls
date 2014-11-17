@isTest
private class TestBPHomeController 
{
	private static testMethod void test1()
	{
		BPHomeController ext = new BPHomeController();

		system.assert(ext.MyJobSeekers != null);
		system.assert(ext.MyFollowUps != null);
		system.assert(ext.MyEmployerContacts != null);

		system.assert(ext.JobSeekerSearchResults != null);
		ext.searchJS();
		system.assert(ext.JobSeekerSearchResults != null);
	}
}