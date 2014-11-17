@isTest
private class TestTriggers 
{
	private static testMethod void testEmployerContact()
	{
		Job_Seeker__c js = TestJobSeekerExtension.insertJobSeeker();

		Employer_Contact__c ec = new Employer_Contact__c();
		ec.Job_Seeker__c = js.ID;
		ec.Result__c = BPConstants.EmployerContact_Result_ResumeDropOff;
		insert ec;

		ec = new Employer_Contact__c();
		ec.Job_Seeker__c = js.ID;
		ec.Result__c = BPConstants.EmployerContact_Result_Interview;
		ec.Interview_Time__c = 'test';
		ec.Interview_Date__c = Date.Today();
		insert ec;

		ec = new Employer_Contact__c();
		ec.Job_Seeker__c = js.ID;
		ec.Result__c = BPConstants.EmployerContact_Result_LeftMessage;
		insert ec;
	}
}