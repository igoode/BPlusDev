@RestResource(urlMapping='/updateSMSDelivery/*')
global class BPWebservices 
{   
    // call using URL https://brokeredplus.force.com/bplus/services/apexrest/updateSMSDelivery/confirm?ref=<refNumber>
    @HttpGet
    global static void confirm()
    {
        updateSMSNotification(RestContext.request.params.get('ref'));
    }

    @TestVisible
    private static void updateSMSNotification(String referenceNumber)
    {
        for(SMS_Notification__c notification : [SELECT ID 
                                                FROM    SMS_Notification__c
                                                WHERE   Name = :referenceNumber])
        {
            notification.Delivered__c = Datetime.now();
            update notification;
        }
    }
     
}