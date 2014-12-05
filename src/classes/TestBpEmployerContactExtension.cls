@isTest
private class TestBpEmployerContactExtension 
{
	private static testMethod void test1()
	{
		Job_Seeker__c js = TestJobSeekerExtension.insertJobSeeker();
		Employer_Contact__c ec = TestJobSeekerExtension.insertEmployerContact(js);
		Test.setCurrentPage(Page.EmployerContact);
		ApexPages.currentPage().getParameters().put('empId', ec.Business__c);

		BPEmployerContactExtension ext = new BPEmployerContactExtension(new ApexPages.StandardController(ec));
		system.assert(ext.Employer != null);

	}
}