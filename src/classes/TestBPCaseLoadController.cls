@isTest
private class TestBPCaseLoadController 
{
	@IsTest(SeeAllData=true)
	private static void test1()
	{
		User u = [SELECT ID 
				FROM 	User 
				WHERE 	IsActive = true  
				LIMIT 1];

		Job_Seeker__c js = TestJobSeekerExtension.insertJobSeeker();
		js.Assigned_To__c = u.ID;
		update js;

		Employer_Contact__c ec = TestJobSeekerExtension.insertEmployerContact(js);
		Follow_Up__c fu = TestJobSeekerExtension.insertFollowup(ec);

		js.Assigned_To__c = u.ID;
		update js;

		System.runAs(u)
		{
			BPCaseLoadController ext = new BPCaseLoadController();

			system.assert(ext.JobSeekers != null);
			system.assert(ext.EmployerContacts != null);
			system.assert(ext.FollowUps != null);
			system.assert(ext.Employers != null);
			system.assert(ext.FUFilter != null);

			ext.rerenderFollowups();

			Test.setCurrentPage(Page.BPAllJobseekers);
			ApexPages.currentPage().getParameters().put('jskId', js.ID);
			ext = new BPCaseLoadController();
			ext.ceaseMarketing();
		}
	}
}