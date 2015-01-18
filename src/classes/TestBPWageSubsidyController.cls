@isTest
private class TestBPWageSubsidyController 
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
        ApexPages.currentPage().getParameters().put('ws13', 'test');
        ApexPages.currentPage().getParameters().put('ws26', 'test');
        ApexPages.currentPage().getParameters().put('hr', 'test');
        ApexPages.currentPage().getParameters().put('ecp', 'test');
		BPWageSubsidyController ext = new BPWageSubsidyController();

		system.assert(ext.Employer != null);
		system.assert(ext.JobSeeker != null);
		system.assert(ext.EmployerContact != null);
		system.assert(ext.UserAccount != null);
		system.assert(ext.Today != null);
		system.assert(ext.ShowPreview != null);
		system.assert(ext.WageSubsidy13Week != null);
		system.assert(ext.WageSubsidy26Week != null);
		system.assert(ext.Hours != null);
		ext.ECMobile = 'test';
		system.assert(ext.ECMobile != null);

		system.assert(ext.preview() != null);
		ext.generateSubsidyAndSend();
		system.assert(ext.sendSubsidy() != null);

		ext.EmployerContact.Contact_Person__c = null;
		ext.EmployerContact.Contact_Email__c = null;
		system.assert(ext.preview() == null);
		system.assert(ext.sendSubsidy() == null);
	}

	private static testMethod void testError()
	{
		BPWageSubsidyController ext = new BPWageSubsidyController();
		ext.testErrorEnabled = true;

		try
		{
			ext.preview();
		}
		catch (Exception ex)
		{}
		try
		{
			ext.generateSubsidyAndSend();
		}
		catch (Exception ex)
		{}
		try
		{
			ext.sendSubsidy();
		}
		catch (Exception ex)
		{}
	}

}