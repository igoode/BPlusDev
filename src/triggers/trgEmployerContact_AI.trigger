trigger trgEmployerContact_AI on Employer_Contact__c(after insert) 
{
	List<Follow_Up__c> followUps = new List<Follow_Up__c>();
	for(Employer_Contact__c ec : Trigger.new)
	{
		if(ec.Result__c == BPConstants.EmployerContact_Result_ResumeDropOff ||
				ec.Result__c == BPConstants.EmployerContact_Result_Interview)
		{
			addFollowup(ec,  BPConstants.FollowUp_Type_CallJobseekerThenEmployer, ec.Interview_Date__c.addDays(1));
			addFollowup(ec,  BPConstants.FollowUp_Type_CallJobseeker, ec.Interview_Date__c.addDays(-1));
		}
		else if(ec.Result__c == BPConstants.EmployerContact_Result_ResumeSent)
		{
			addFollowup(ec,  BPConstants.FollowUp_Type_CallEmployer, Date.today().addDays(1));
		}
		else if(ec.Result__c == BPConstants.EmployerContact_Result_LeftMessage  || 
					ec.Result__c == BPConstants.EmployerContact_Result_Callback)
		{
			addFollowup(ec,  BPConstants.FollowUp_Type_CallEmployer, Date.today().addDays(2));
		}
		else if(ec.Result__c == BPConstants.EmployerContact_Result_NoAnswer)
		{
			addFollowup(ec,  BPConstants.FollowUp_Type_CallEmployer, Date.today().addDays(3));
		}
	}
	insert followUps;

	private void addFollowup(Employer_Contact__c ec, String type, Date dueDate)
	{
		Follow_Up__c fu = BPFollowupExtension.createFollowUp(ec, type, dueDate);
		followUps.add(fu);
	}
}