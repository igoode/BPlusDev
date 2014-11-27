@isTest
private class TestBPHelpController 
{
	private static testMethod void test1()
	{
		BPHelpController ext = new BPHelpController();

		ext.Question = 'test';
		system.assert(ext.Question == 'test');

		ext.sendEmail();

		try
		{
			ext.testErrorEnabled = true;
			ext.sendEmail();
		}
		catch (Exception ex)
		{}
	}
}