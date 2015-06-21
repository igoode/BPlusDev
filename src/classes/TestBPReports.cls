@isTest
private class TestBPReports 
{
	private static testMethod void  test1()
	{
		Job_Seeker__c js = TestJobSeekerExtension.insertJobSeeker();
		Follow_Up__c fu = new Follow_Up__c();
		fu.Job_Seeker__c = js.ID;
		fu.Employer_Contact__c = TestJobSeekerExtension.insertEmployerContact(js).ID;
		fu.Action_Taken__c = BPConstants.EmployerContact_Result_LeftMessage;
		insert fu;

		js.Placed_Date__c = Date.today();
		update js;

		Employer_Contact__c ec = new Employer_Contact__c(ID = fu.Employer_Contact__c);
		ec.Result__c = BPConstants.EmployerContact_Result_Interview;
		ec.Interview_Date__c = Date.today();
		ec.Interview_Time__c = 'test';
		update ec;

		Test.setCurrentPage(Page.BPReports);
		BPReports ext = new BPReports();

		system.assert(ext.Periods != null);
		system.assert(ext.JobSeekers != null);
		system.assert(ext.ECs != null);		
		system.assert(ext.SiteECs != null);


		system.assert(ext.ECPerfomance != null);
		for(BPReports.ECWrapper w : ext.ECPerfomance)
		{
			system.assert(w.Placements != null);
			system.assert(w.Meetings != null);
			system.assert(w.Followups != null);
			system.assert(w.FollowupsCompleted != null);
			system.assert(w.FollowupRatio != null);
			system.assert(w.Calls != null);
			system.assert(w.MeetingRatio != null);
			system.assert(w.PlacementRatio != null);
			system.assert(w.NoFurtherAction != null);
			system.assert(w.ResumesSent != null);
			system.assert(w.Disconnected != null);
			system.assert(w.NoVacancy != null);
			system.assert(w.Vacancy != null);
			system.assert(w.WageSubsidies != null);
			system.assert(w.MeetingPlacementRatio != null);
			system.assert(w.NoAnswerRatio != null);
			system.assert(w.NoFurtherActionRatio != null);
			system.assert(w.ResumeToMeetingRatio != null);
		} 

		ext.SelectedPeriod = null;
		ext.setDates();

		ext.SelectedPeriod = '1';
		ext.setDates();

		ext.SelectedPeriod = '2';
		ext.setDates();

		ext.SelectedPeriod = '3';
		ext.setDates();

		ApexPages.currentPage().getParameters().put('rp', 'test');
		ext.openReport();

		ApexPages.currentPage().getParameters().put('jskId', js.ID);
		system.assert(ext.JobSeeker != null);

		system.assert(ext.parseDate(null, null) == null);
		system.assert(ext.parseDate(Date.today().format(), Date.today()) == Date.today());
		system.assert(ext.parseDate('bad date', Date.today()) == null);
	}

	private static testMethod void  testErrors()
	{
		Test.setCurrentPage(Page.BPReports);
		BPReports ext = new BPReports();
		ext.testErrorEnabled = true;

		try
		{
			ext.openReport();
		}
		catch(Exception ex)
		{}
		try
		{
			ext.setDates();
		}
		catch(Exception ex)
		{}
	}	
}