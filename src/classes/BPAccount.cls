public without sharing class BPAccount
{
    public static Account getAccount(String accountID)
    {
    	return [SELECT ID,
    					Name,
    					Wage_Subsidy_Logo__c
				FROM 	Account
				WHERE 	ID = :accountID];
    }
}