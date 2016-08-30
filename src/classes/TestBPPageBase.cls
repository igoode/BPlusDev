@isTest
public class TestBPPageBase 
{
	@IsTest(SeeAllData=true)
	private static void test1()
	{
		BPPageBaseTest ext = new BPPageBaseTest();
		ext.runAllMethods();

		ext = new BPPageBaseTest();
		ext.runAllMethods2();

	}

	public class BPPageBaseTest
		extends BPPageBase 
	{
		public void runAllMethods()
		{
			addMessage(new BPException('test'));
			addMessage('test');
			addMessage(new BPException('test'), null);
			getParameter('test');
			getSelectListFromObjectList([SELECT ID, NAME FROM Account LIMIT 1], 'ID', 'Name');
			getSelectListFromObjectList([SELECT ID, NAME FROM Account LIMIT 1], 'ID', 'Name', false);
			getSelectListFromPicklistField(Follow_up__c.Type__c, true);

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
			System.assert(ThisController != null);

			PlacedDate = Date.today();
			System.assert(PlacedDate == Date.today());

			addMessage(new BPException('', null));
						System.assert(getSelectListFromObjectList(new List<sObject>(), false) != null);
			MobileNumber = '0404240508';
			System.assert(MobileNumber == '0404240508');
			setMobileNumber(js, 'test'); 

			getLiveSession();
			rerenderPage();
			validateMobileNumber('0412345678');
			validateMobileNumber(null, false);

			getLiveSession();

		}

		public void runAllMethods2()
		{
			Test.setCurrentPage(Page.FollowUp);
			for(Employer_Contact__c ec : [SELECT ID,
												Business__c,
												Job_Seeker__c
										FROM 	Employer_Contact__c 
										LIMIT 1])
			{
				jobSeekerID = ec.Job_Seeker__c;
				ApexPages.currentPage().getParameters().put('empId',ec.Business__c);
				ApexPages.currentPage().getParameters().put('ecId',ec.ID);
				JobSeeker.Placed_Date__c = Date.today();
				placedJobSeeker();
			}

		}
	}
}