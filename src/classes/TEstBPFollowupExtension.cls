@isTest
private class TestBPFollowupExtension 
{
	private static testMethod void test1()
	{
		Job_Seeker__c js = TestJobSeekerExtension.insertJobSeeker();

		Follow_Up__c fu = new Follow_Up__c();
		fu.Job_Seeker__c = js.ID;

		Employer_Contact__c ec = TestJobSeekerExtension.insertEmployerContact(js);
		fu.Employer_Contact__c = ec.ID;
		fu.Action_Taken__c = BPConstants.EmployerContact_Result_LeftMessage;
		insert fu;

		BPFollowupExtension ext = new BPFollowupExtension(new ApexPages.StandardController(fu));
		

		ext.VacancyJobSeeker = null;
		system.assert(ext.VacancyJobSeeker != null);

		ext.NextContact = null;
		system.assert(ext.NextContact != null);

		ext.JobSeekerSearch = js.Name;

		ApexPages.currentPage().getParameters().put('newJsId', js.ID);

		ext.saveOverride();

		ext.sendEmployerDetails();

		BPFollowupExtension.sendSMS(js, 'test', 'test');

		system.assert(ext.RelatedFollowUps != null);
		system.assert(ext.RelatedContacts != null);

		ext.redir();
		Employer_Contact__c vacancyEc = new Employer_Contact__c();
		vacancyEc.Result__c = BPConstants.EmployerContact_Result_Vacancy;
		vacancyEc.Business__c = ec.Business__c;
		vacancyEc.Open_Vacancy__c = true;
		insert vacancyEc;

		Follow_Up__c newFu = fu.clone(false, true);
		newFu.Employer_Contact__c = vacancyEc.ID;
		newFu.Open_Vacancy__c = true;
		insert newFu;
		
		ext = new BPFollowupExtension(new ApexPages.StandardController(newFu));

		ext.saveVacancy();
		newFu.Assigned_To__c = UserInfo.getUserId();
		ext.saveVacancy();

		ext.redir();

		ext.closeVacancy();
		ext.openVacancy();

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
		try
		{
			ext.redir();
		}
		catch (Exception ex)
		{}
		try
		{
			ext.saveVacancy();
		}
		catch (Exception ex)
		{}
		try
		{
			ext.openVacancy();
		}
		catch (Exception ex)
		{}
		try
		{
			ext.closeVacancy();
		}
		catch (Exception ex)
		{}
	}
}