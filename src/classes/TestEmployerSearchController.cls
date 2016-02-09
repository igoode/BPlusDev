@isTest
private class TestEmployerSearchController 
{
	@IsTest(SeeAllData=true)
	private static void test1()
	{
		Job_Seeker__c js = TestJobSeekerExtension.insertJobSeeker();

		Job_Category__c jc1 = new Job_Category__c(Name = 'test1');
        jc1.Targeted__c = false;
        insert jc1;

		Job_Category__c jc2 = new Job_Category__c(Name = 'test2');
        jc2.Targeted__c = true;
        jc2.Parent_Category__c = jc1.ID;
        insert jc2;

        Industry__c ind1 = new Industry__c(Name = 'Atest');
        insert ind1;
        ind1 = new Industry__c(Name = 'Gtest');
        insert ind1;
        ind1 = new Industry__c(Name = 'Ntest');
        insert ind1;
        Industry__c ind2 = new Industry__c(Name = 'Ttest');
        ind2.Job_Category__c = jc2.ID;
        ind2.Survival_Job__c = true;
        ind2.Sensis_Category_ID__c = '23078'; // this is in the dummy search response
        insert ind2;


        Job__c job = new Job__c(Name = 'test');
        job.Industry1__c = ind1.ID;
        job.Industry2__c = ind2.ID;
        job.Industry3__c = ind2.ID;
        job.Industry4__c = ind2.ID;
        job.Industry5__c = ind2.ID;
		insert job;

		js.Last_Marketed_EC__c = UserInfo.getUserID();
        js.Last_Marketed_Page__c = '1';
        js.Last_Marketed_Search_Category__c = 'test';
        js.Last_Marketed_Search_Type__c =  'Keyword';
        js.Last_Marketed_Search_Radius__c = 1;
        js.Last_Marketed_Alt_Location__c = 'test';
        update js;

		EmployerSearchController ext = new EmployerSearchController(new ApexPages.StandardController(js));
		ext.resumeSearch();

		system.assert(ext.JobSeeker != null);
		system.assert(ext.EmployerContact != null);
		system.assert(ext.MapUrl != null);
		system.assert(ext.Top40Jobs != null);
		system.assert(ext.TargetedJobCategories != null);
		system.assert(ext.IndustriesByIndex != null);
		system.assert(ext.BusinessessBySensisID != null);
		system.assert(ext.NextAddressDisplay != null);
		system.assert(ext.ResultOptions != null);

		Test.setCurrentPage(Page.EmployerSearch);

		ApexPages.currentPage().getParameters().put('industryId', ind2.Sensis_Category_ID__c);
		ext.doIndustrySearch();

		ApexPages.currentPage().getParameters().put('categoryId', ind2.Job_Category__c);
		ext.doJobSearch();

		ApexPages.currentPage().getParameters().put('jobId', job.ID);
		ext.doSurvivalJobSearch();

		ext.getEmployer();

		ext.SelectedBusiness.Sensis_ID__c = 'test';
		ext.EmployerContact.Result__c = 'test';
		ext.saveContact();

		ext.Keyword = 'test';
		ext.doKeywordSearch();

		ext.sendEmployerDetails();

		ext.clearSearch();

		ext.CurrentPage = '1';
		ext.SearchResults = null;
		system.assert(ext.SearchResults != null); 

		ext.notifyJobSeeker();

		ext.goJobseeker();

 		ext.goHome();

 		ext.PrevPage = '1';
 		ext.TotalPages = '2';
 		system.assert(ext.PrevPage == '1');
 		system.assert(ext.TotalPages == '2'); 		
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
		try
		{
			ext.notifyJobSeeker();
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