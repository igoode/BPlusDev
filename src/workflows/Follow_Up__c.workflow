<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Set Reminder</fullName>
        <active>true</active>
        <formula>Assigned_To__r.Contact.Account.Send_Reminder_Emails__c &amp;&amp; NOT(ISPICKVAL(Type__c, &apos;&apos;)) &amp;&amp; NOT(ISBLANK(Due_Date__c)) &amp;&amp; ISBLANK(Job_Seeker__r.Marketing_Ended__c) &amp;&amp; NOT( No_Further_Action_Required__c)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Follow_Up__c.Due_Date__c</offsetFromField>
            <timeLength>-1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
