@isTest
public class TestBPPageBase 
{
	@IsTest(SeeAllData=true)
	private static void test1()
	{
		BPPageBaseTest ext = new BPPageBaseTest();
		ext.runAllMethods();

	}

	public class BPPageBaseTest
		extends BPPageBase 
	{
		public void runAllMethods()
		{
			addMessage(new BPException('test'));
			addMessage('test');
			getParameter('test');
			getSelectListFromObjectList([SELECT ID, NAME FROM Account LIMIT 1], 'ID', 'Name');
			getSelectListFromObjectList([SELECT ID, NAME FROM Account LIMIT 1], 'ID', 'Name', false);
			Job_Seeker__c js = new Job_Seeker__c();
			isRequiredFieldValid(js.Name, 'test', false);

			addMessage(ApexPages.Severity.Error, 'test');

			system.assert(CurrentUser != null);
			System.assert(ResumeDropOff != null);
			System.assert(CallBack != null);
			System.assert(Interview != null);
			System.assert(LiveSession != null);
			jobSeekerID = [SELECT ID FROM Job_Seeker__c LIMIT 1].ID;
			System.assert(JobSeeker != null);
			System.assert(Consultants != null);
			System.assert(IsManager != null);
			System.assert(IsAdmin != null);
			System.assert(CommunicationRecordTypesByName != null);
			addMessage(new BPException('', null));
						System.assert(getSelectListFromObjectList(new List<sObject>(), false) != null);
			MobileNumber = 'Test';
			System.assert(MobileNumber == 'Test');
			getLiveSession();
			rerenderPage();
			validateMobileNumber('0412345678');

		}
	}
}