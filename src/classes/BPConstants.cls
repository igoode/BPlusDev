public class BPConstants 
{
	public static final Integer MAX_FUTURE_JOBS = 90;

	public static final String Profile_SystemAdministrator = 'System Administrator';
	public static final String Profile_BPlusCommunity = 'BPlus Community';
	public static final String Profile_BPlusManager = 'BPlus Manager';

	public static final String FollowUp_RecordType_Followup = 'Followup';
	public static final String FollowUp_RecordType_SignupComplete = 'SignupComplete';

	public static final ID FollowUp_RecordType_Followup_ID = Follow_Up__c.SObjectType.getDescribe().getRecordTypeInfosByName().get(FollowUp_RecordType_Followup).getRecordTypeId();
	public static final ID FollowUp_RecordType_SignupComplete_ID = Follow_Up__c.SObjectType.getDescribe().getRecordTypeInfosByName().get(FollowUp_RecordType_SignupComplete).getRecordTypeId();

	public static final String EmailTemplate_OpenVacancy = 'Open_Vacancy';

	public static final String FollowUp_Type_Resume = 'Resume';
	public static final String FollowUp_Type_Interview = 'Interview';
	public static final String FollowUp_Type_CallEmployer = 'Call Employer';
	public static final String FollowUp_Type_CallJobseeker = 'Call Jobseeker';
	public static final String FollowUp_Type_CallJobseekerThenEmployer = 'Call Jobseeker then Employer';
	public static final String FollowUp_Type_SendAnotherJobseeker = 'Send Another Jobseeker';
	public static final String FollowUp_Type_WageSubsidySent = 'Wage Subsidy Sent';
	public static final String FollowUp_Type_CommencedETS = 'Commenced/ETS';
	public static final String FollowUp_Type_OpenVacancy = 'Open Vacancy';
	public static final String FollowUp_Type_VacancyAssigned = 'Vacancy Assigned';
	public static final String FollowUp_Type_Vacancy = 'Vacancy';
	public static final String FollowUp_Type_Communication = 'Communication';
	public static final String FollowUp_Type_Placed = 'Placed';

	public static final String FollowUp_ActionTaken_SentAnotherJobseeker = 'Sent Another Jobseeker';
	public static final String FollowUp_ActionTaken_ResumeSent  = 'Resume sent';

	public static final String EmployerContact_Result_Interview = 'Interview';
	public static final String EmployerContact_Result_ResumeDropOff = 'Resume drop off';
	public static final String EmployerContact_Result_ResumeSent = 'Resume sent / apply online';
	public static final String EmployerContact_Result_Resume_Sent = 'Resume sent';
	public static final String EmployerContact_Result_LeftMessage = 'Left message';
	public static final String EmployerContact_Result_DoNotDisturb = 'Do not disturb';
	public static final String EmployerContact_Result_NoAnswer = 'No Answer';
	public static final String EmployerContact_Result_Callback = 'Call back';
	public static final String EmployerContact_Result_Vacancy = 'Vacancy';
	public static final String EmployerContact_Result_AssignedToVacancy = 'Assigned to vacancy';
	public static final String EmployerContact_Result_Disconnected = 'Disconnected';
	public static final String EmployerContact_Result_NoVacancy = 'No Vacancy';
	public static final String EmployerContact_Result_Email = 'Email';
	public static final String EmployerContact_Result_Placed = 'Placed';
	//public static final String EmployerContact_Result_WorktrialOrganised = 'Work trial organised';
	public static final String EmployerContact_Result_NegativeFeedback = 'Negative employer feedback re JSK';
	public static final String EmployerContact_Result_WorkTrial = 'Paid work trial';
	public static final String EmployerContact_Result_FailedToAttend = 'Failed to attend';
	public static final String EmployerContact_Result_DeclinedEmployment = 'Declined Employment';

	public static final String EmployerContact_Result_Signup = 'Signup';
	public static final String EmployerContact_Result_AEPSignup = 'AEP Signup';
	public static final String EmployerContact_Result_AMPSignup = 'AMP Signup';
	public static final String EmployerContact_Result_AASNSignup = 'AASN Signup';
	public static final String EmployerContact_Result_Referral = 'Referral';

	public static final String SMSMNotification_Type_CommencedMarketing = 'Commenced Marketing';
	public static final String SMSMNotification_Type_Interview = 'Interview';
	public static final String SMSMNotification_Type_EmployerMeeting = 'Employer Meeting';
	public static final String SMSMNotification_Type_EmployerDetails = 'Employer Details';

	public static final String Communication_RecordType_WageSubsidy = 'Wage Subsidy';
	public static final String Communication_RecordType_SMSNotification = 'SMS Notification';
	public static final String Communication_RecordType_Email = 'Email';
}