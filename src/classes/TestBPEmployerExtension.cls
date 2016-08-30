@isTest
private class TestBPEmployerExtension 
{
	private static testMethod void test1()
	{
		Job_Seeker__c js = TestJobSeekerExtension.insertJobSeeker();
		Employer_Contact__c ec = TestJobSeekerExtension.insertEmployerContact(js);
		Follow_Up__c fu = TestJobSeekerExtension.insertFollowup(ec);
		Business__c b = [SELECT ID, 
								Name,
								Sensis_ID__c, 
								Google_Place_ID__c, 
								Location__c
						FROM Business__c 
						WHERE ID = :ec.Business__c];
		b.Location__c = 'Aldgate,SA';
		BPEmployerExtension ext = new BPEmployerExtension(new ApexPages.StandardController(b));

		system.assert(ext.EmployerContacts != null);
		system.assert(ext.Followups != null);
		system.assert(ext.Subsidies != null);

		ext.newContact();

		ext.SearchLocation = 'test';
		system.assert(ext.SearchLocation == 'test');

		ext.SearchState = 'test';
		system.assert(ext.SearchState == 'test');

		system.assert(ext.PlacementOptions != null);
		system.assert(ext.Emails != null);

		system.assert(ext.StateList != null);
		system.assert(ext.JobSeekerAttributesByGroup != null);



		ext.SearchLocation = 'test'; 
		ext.SearchState = 'test'; 
		ext.checkListing();

        ext.newEmployerContact();
        ext.newContact();

		ext.saveOverride();
	}
}