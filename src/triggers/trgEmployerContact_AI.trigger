trigger trgEmployerContact_AI on Employer_Contact__c(before insert, before update)
{
	for(Employer_Contact__c ec : Trigger.new)
	{
		if(ec.Activity_Result__c != null)
		{
			ec.Result__c = ec.Activity_Result__c;
		}
	}
}