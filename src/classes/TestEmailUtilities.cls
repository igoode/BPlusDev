@isTest
private class TestEmailUtilities 
{
	private static testMethod void test1()
	{		
		EmailUtilities.sendHTMLMessage('ian@gtmgroup.com.au', 'test', 'test', 'test', 'test@test.com');
		EmailUtilities.sendMessage(new String[]{'ian@gtmgroup.com.au'}, null, 'test', 'test', 'test', 'test@test.com', false);

		User u = [SELECT ID FROM User WHERE IsActive = true LIMIT 1];
		EmailUtilities.sendMessage(new String[]{'ian@gtmgroup.com.au'}, u.ID, 'test', 'test', 'test', 'test@test.com', false);
	}
}