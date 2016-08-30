@isTest
private class TestBPCommunicationsController 
{
	private static testMethod void test1()
	{
		Job_Seeker__c js = TestJobSeekerExtension.insertJobSeeker();
		Employer_Contact__c ec = TestJobSeekerExtension.insertEmployerContact(js);

		Test.setCurrentPage(Page.BPWageSubsidy);
		ApexPages.currentPage().getParameters().put('empId', ec.Business__c);
		ApexPages.currentPage().getParameters().put('jskId', js.ID);
		ApexPages.currentPage().getParameters().put('ea', 'test');
        ApexPages.currentPage().getParameters().put('cp', 'test');
        ApexPages.currentPage().getParameters().put('ce', 'test@test.com');
        ApexPages.currentPage().getParameters().put('ws4', 'test');
        ApexPages.currentPage().getParameters().put('ws13', 'test');
        ApexPages.currentPage().getParameters().put('ws26', 'test');
        ApexPages.currentPage().getParameters().put('hr', 'test');
        ApexPages.currentPage().getParameters().put('ecp', 'test');
		BPCommunicationController ext = new BPCommunicationController();

		system.assert(ext.Employer != null);
		system.assert(ext.JobSeeker != null);
		system.assert(ext.EmployerContact != null);
		system.assert(ext.UserAccount != null);
		system.assert(ext.Today != null);
		system.assert(ext.WageSubsidy13Week != null);
		system.assert(ext.WageSubsidy26Week != null);
		system.assert(ext.Hours != null);
		system.debug(ext.Brochure);
		ext.ECMobile = 'test';
		system.assert(ext.ECMobile != null);
		ext.IncludeResume = true;
		ext.ResumeBody = Blob.valueOf('test');
		ext.FileName = 'test';
		ext.FileType = 'test';
		ext.send();

		ext.send();

		ext.EmployerContact.Contact_Person__c = null;
		ext.EmployerContact.Contact_Email__c = null;

		ext.send();
	}

	private static testMethod void testError()
	{
		BPCommunicationController ext = new BPCommunicationController();
		ext.testErrorEnabled = true;

		try
		{
			ext.send();
		}
		catch (Exception ex)
		{}
	}

}