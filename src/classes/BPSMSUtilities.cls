public with sharing class BPSMSUtilities 
{
    private static String BaseURL
    {
        get
        {
            return SMS_Settings__c.getInstance().URL__c + 
                    'username=' + 
                    SMS_Settings__c.getInstance().Username__c + 
                    '&password=' + 
                    SMS_Settings__c.getInstance().Password__c;
        }
    }
    
    public static String sendSMS(String message, String phNumber, Integer reference)
    {
    	return sendSMS(message, phNumber, reference, true);
    }

    private static String sendSMS(String message, String phNumber, Integer reference, Boolean checkBalance)
    {
        if(String.isBlank(phNumber))
        {
            throw new BPException('Mobile phone number is required to send an SMS.');
        }
        phNumber = cleanPhoneNumber(phNumber);     
        if(checkBalance)
        {
            Integer balance = getBalance(Test.isRunningTest());
            if(balance < SMS_Settings__c.getInstance().Minimum_Balance__c)
            {
                if(balance == 0)
                {
                    return null;
                }
                if(balance < 10)
                {
                    sendSMS('Credit low (' + balance.format() + ')', '0404240508', 9999999, false);
                }
            }
        }

        message = EncodingUtil.urlEncode(message, 'UTF-8');
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        String url = BaseURL + 
                        '&to=' + phNumber + 
                        '&from=' + SMS_Settings__c.getInstance().From__c + 
                        '&message=' + message + 
                        (reference == null ? '' : ('&ref=' + reference.format().replace(',', ''))) + 
                        '&maxsplit=5';
        request.setEndPoint(url);
        String[] response;
        if(Test.isRunningTest())
        {
           response = new String[]{'test', 'test', 'test'};
        }
        else
        {
            Http http = new Http();
            HTTPResponse res = http.send(request);
            response = res.getBody().split(':');
        }
       
        if(response.size() > 0)
        {
            if(response[0] == 'BAD')
	        {
	            throw new BPException('SMS gateway rejected the message due to an invalid number.');
	        }
            else if(response[0] == 'ERROR')
            {
                throw new BPException(response[1]);
            }
            return response[2];
        }
        return null;
    }

    public static String cleanPhoneNumber(String phNumber)
    {
        phNumber = phNumber.replace('(', '').replace(')', '').deleteWhitespace();
        Pattern mobilePattern = Pattern.compile('04[0-9]{8}');
        if(!(mobilePattern.matcher(phNumber).matches()))
        {
            throw new BPException('Mobile phone number must be in the format 0499999999.');
        }
        return phNumber;
    }

    @TestVisible
    private static Integer getBalance(Boolean isTest)
    {
        Integer minBalance = Test.isRunningTest() ? 20 : SMS_Settings__c.getInstance().Minimum_Balance__c.intValue();
    	try
    	{
	        HttpRequest request = new HttpRequest();
	        request.setMethod('POST');
	        request.setEndPoint(BaseUrl + '&action=balance');
	        Http http = new Http();
	         String[] response;
            if(Test.isRunningTest())
            {
               response = new String[]{'test', '1'};
            }
            else
            {
    	        HTTPResponse res = http.send(request);	        
    	        response = res.getBody().split(':');
            }
	        if(response.size() != 2 || response[0] == 'ERROR')
	        {
	            return minBalance;
	        }   
        	return Integer.valueOf(response[1]); 
    	}
    	catch(Exception ex)
    	{
    		return minBalance;
    	}
    }
}