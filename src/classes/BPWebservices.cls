@RestResource(urlMapping='/updateSMSDelivery/*')
global class BPWebservices 
{   
    // call using URL https://brokeredplus.force.com/bplus/services/apexrest/updateSMSDelivery/confirm?ref=<refNumber>
    @HttpGet
    global static void confirm()
    {
        String smsref = RestContext.request.params.get('smsref');
        String status = RestContext.request.params.get('status');

        updateSMSNotification(smsref, status);
    }

    @TestVisible
    private static void updateSMSNotification(String referenceNumber, String status)
    {
        for(SMS_Notification__c notification : [SELECT  ID 
                                                FROM    SMS_Notification__c
                                                WHERE   Gateway_Reference__c = :referenceNumber AND 
                                                        Gateway_Reference__c != null])
        {
            notification.Delivered__c = Datetime.now();
            notification.Delivery_Status__c = status;
            update notification;
        }
    }
     
}