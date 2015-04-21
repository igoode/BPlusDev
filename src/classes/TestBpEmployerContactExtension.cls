@isTest
private class TestBpEmployerContactExtension 
{
	private static testMethod void test1()
	{
		Job_Seeker__c js = TestJobSeekerExtension.insertJobSeeker();
		Employer_Contact__c ec = TestJobSeekerExtension.insertEmployerContact(js);
		Test.setCurrentPage(Page.EmployerContact);
		ApexPages.currentPage().getParameters().put('empId', ec.Business__c);
		ApexPages.currentPage().getParameters().put('jsId', js.LastModifiedById);

		BPEmployerContactExtension ext = new BPEmployerContactExtension(new ApexPages.StandardController(ec));
		ext.getEmployerAddress();

		ext.Employer = null;
		system.assert(ext.Employer != null);

		ext.smsDetails();

		ec.Result__c =  BPConstants.EmployerContact_Result_ResumeDropOff;
		ec.Interview_Date__c = Date.today();
		ec.Interview_Time__c = 'test';
		ext.saveOverride();


		ext.getJobSeeker();

	}
}