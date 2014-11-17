global class BPWebservices 
{
    webservice static void confirmSMSDelivery(String referenceNumber)
    {
        for(SMS_Notification__c notification : [SELECT ID 
        										FROM 	SMS_Notification__c
        										WHERE 	Name = :referenceNumber])
    	{
    		notification.Delivered__c = Datetime.now();
    		update notification;
    	}
    }
     
}