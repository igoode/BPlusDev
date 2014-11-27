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
		}
	}
}