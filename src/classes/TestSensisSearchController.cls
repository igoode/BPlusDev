@isTest
public class TestSensisSearchController 
{
	@IsTest(SeeAllData=true)
	private static void test1()
	{
		SensisSearchController ext = new SensisSearchController();

		ext.doSearchByQuery('test', 'test', 'test', 'test');
		ext.doSearchByCategory('test', 'test', 'test', 'test');

		system.assert(ext.TotalPages != null);
		system.assert(ext.PageNumber != null);

		ext.doSearchByCategory(null, null, null, null);
		ext.doSearchByCategory('test', 'test', 'test', null);
	}
}