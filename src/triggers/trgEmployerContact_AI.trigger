trigger trgEmployerContact_AI on Employer_Contact__c(after insert) 
{
	List<Follow_Up__c> followUps = new List<Follow_Up__c>();
	for(Employer_Contact__c ec : Trigger.new)
	{
		if(ec.Result__c == BPConstants.EmployerContact_Result_ResumeDropOff ||
				ec.Result__c == BPConstants.EmployerContact_Result_Interview)
		{
			Integer daysAhead = Date.today().daysBetween(ec.Interview_Date__c);
			addFollowup(ec,  BPConstants.FollowUp_Type_CallJobseekerThenEmployer, daysAhead);
		}
		else if(ec.Result__c == BPConstants.EmployerContact_Result_ResumeSent)
		{
			addFollowup(ec,  BPConstants.FollowUp_Type_CallEmployer, 1);
		}
		else if(ec.Result__c == BPConstants.EmployerContact_Result_LeftMessage)
		{
			addFollowup(ec,  BPConstants.FollowUp_Type_CallEmployer, 2);
		}
		else if(ec.Result__c == BPConstants.EmployerContact_NoAnswer)
		{
			addFollowup(ec,  BPConstants.FollowUp_Type_CallEmployer, 3);
		}
	}
	insert followUps;

	private void addFollowup(Employer_Contact__c ec, String type, Integer dueDaysAhead)
	{
		Follow_Up__c fu = new Follow_Up__c(Employer_Contact__c = ec.ID);
		fu.Due_Date__c = Date.today().addDays(dueDaysAhead);
		fu.Type__c = type;
		fu.Assigned_To__c = ec.User__c;
		fu.Job_Seeker__c = ec.Job_Seeker__c;
		followUps.add(fu);
	}
}