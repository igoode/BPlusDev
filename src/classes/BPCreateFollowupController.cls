public with sharing class BPCreateFollowupController 
	extends BPPageBase
{
    public BPCreateFollowupController() {
}

     public Follow_Up__c NewEmployerFollowup
    {
        get 
        {
            if(NewEmployerFollowup == null)
            {
                NewEmployerFollowup = new Follow_Up__c(Type__c = BPConstants.FollowUp_Type_CallEmployer);
            }
            return NewEmployerFollowup;
        }
        set;
    }

    public Follow_Up__c NewJobseekerFollowup
    {
        get 
        {
            if(NewJobseekerFollowup == null)
            {
                NewJobseekerFollowup = new Follow_Up__c(Type__c = BPConstants.FollowUp_Type_CallJobseeker);
            }
            return NewJobseekerFollowup;
        }
        set;
    }

    public void createFollowup()
    {
        try
        {
            /*PageReference pg = Page.FollowUp;
            //followUp = new Follow_Up__c(Employer_Contact__c = followup.Employer_Contact__c, Job_Seeker__c = followup.Job_Seeker__c);
            pg.getParameters().put('jskId', followup.Job_Seeker__c);
            pg.getParameters().put('ecId', followup.Employer_Contact__c);
            pg.getParameters().put('empId', followup.Employer_Contact__r.Business__c);
            return pg.setRedirect(true);*/
 system.debug(getParameter('necID') );     
            for(Employer_Contact__c ec : [SELECT ID, 
                                                Job_Seeker__c 
                                        FROM    Employer_Contact__c 
                                        WHERE   ID = :getParameter('necID')])
            {
                Integer i = 0;
                if(NewEmployerFollowup.Due_Date__c != null)
                {
                    NewEmployerFollowup.Employer_Contact__c = ec.ID;
                    NewEmployerFollowup.Job_Seeker__c =  ec.Job_Seeker__c;
                    upsert NewEmployerFollowup;
                    i++;
                }
                if(NewJobseekerFollowup.Due_Date__c != null)
                {
                    NewJobseekerFollowup.Employer_Contact__c = ec.ID;
                    NewJobseekerFollowup.Job_Seeker__c = ec.Job_Seeker__c;
                    upsert NewJobseekerFollowup;
                    i++;
                }
                if(i > 0)
                {
                    addMessage(ApexPages.Severity.INFO, String.valueOf(i) + ' new followup(s) created.');
                }
                else
                {
                    addMessage('Followup date is required');
                }
            }
        }
        catch(Exception ex)
        {
            addMessage(ex);
        }
    }

}