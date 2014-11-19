@isTest
private class TestEmployerSearchController 
{
	private static testMethod void test1()
	{
		Job_Seeker__c js = TestJobSeekerExtension.insertJobSeeker();

		Job_Category__c jc1 = new Job_Category__c(Name = 'test1');
        jc1.Targeted__c = false;
        insert jc1;

		Job_Category__c jc2 = new Job_Category__c(Name = 'test2');
        jc2.Targeted__c = true;
        jc2.Parent_Category__c = jc1.ID;
        insert jc2;

        Industry__c ind1 = new Industry__c(Name = 'test');
        insert ind1;

        Industry__c ind2 = new Industry__c(Name = 'test');
        ind2.Job_Category__c = jc2.ID;
        ind2.Survival_Job__c = true;
        ind2.Sensis_Category_ID__c = '23078'; // this is in the dummy search response
        insert ind2;

        Job__c job = new Job__c(Name = 'test');
        job.Job_Category1__c = jc2.ID;
        job.Job_Category2__c = jc2.ID;
        job.Job_Category3__c = jc2.ID;
		insert job;

		EmployerSearchController ext = new EmployerSearchController(new ApexPages.StandardController(js));

		system.assert(ext.JobSeeker != null);
		system.assert(ext.EmployerContact != null);
		system.assert(ext.MapUrl != null);
		system.assert(ext.Top40Jobs != null);
		system.assert(ext.TargetedJobCategories != null);
		system.assert(ext.Industries != null);

		Test.setCurrentPage(Page.EmployerSearch);
		ApexPages.currentPage().getParameters().put('industryId', ind2.Sensis_Category_ID__c);
		ext.doIndustrySearch();

		ApexPages.currentPage().getParameters().put('categoryId', ind2.Job_Category__c);
		ext.doJobSearch();

		ApexPages.currentPage().getParameters().put('jobId', job.ID);
		ext.doSurvivalJobSearch();

		ext.getEmployer();

		ext.saveContact();

		ext.CurrentPage = '1';
		ext.SearchResults = null;
		system.assert(ext.SearchResults != null); 

		ext.goJobseeker();
 		ext.goHome();
    }

	private static testMethod void testError()
	{
		Job_Seeker__c js = TestJobSeekerExtension.insertJobSeeker();
		EmployerSearchController ext = new EmployerSearchController(new ApexPages.StandardController(js));

		ext.testErrorEnabled = true;
		try
		{
			ext.doIndustrySearch();
		}
		catch(Exception ex)
		{}
		try
		{
			ext.doJobSearch();
		}
		catch(Exception ex)
		{}
		try
		{
			ext.doSurvivalJobSearch();
		}
		catch(Exception ex)
		{}
		try
		{
			ext.saveContact();
		}
		catch(Exception ex)
		{}
		try
		{
			ext.getEmployer();
		}
		catch(Exception ex)
		{}
		try
		{
			ext.goHome();
		}
		catch(Exception ex)
		{}
		try
		{
			ext.goJobseeker();
		}
		catch(Exception ex)
		{}
	}

	@IsTest(SeeAllData=true) 
	private static void testAccount()
	{
		Job_Seeker__c js = TestJobSeekerExtension.insertJobSeeker();

		EmployerSearchController ext = new EmployerSearchController(new ApexPages.StandardController(js));

		system.assert(ext.CommunityAccount != null);
	}
}