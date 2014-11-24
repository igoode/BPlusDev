trigger trgAccount_AIAU on Account(after insert, after update) 
{
	List<AccountShare> accountShares = new List<AccountShare>();
	Map<ID, List<UserRole>> userRolesByAccountID = new Map<ID, List<UserRole>>();
	for(UserRole uRole : [SELECT ID,
								PortalAccountId
						FROM 	UserRole
						WHERE 	PortalAccountId IN :Trigger.new])
	{
		if(!userRolesByAccountID.containsKey(uRole.PortalAccountId))
		{
			userRolesByAccountID.put(uRole.PortalAccountId, new List<UserRole>());
		}
		userRolesByAccountID.get(uRole.PortalAccountId).add(uRole);
	}

	for(Account a : Trigger.new)
	{
		if(userRolesByAccountID.containsKey(a.Id))
		{
			for(UserRole uRole : userRolesByAccountID.get(a.ID))
			{
				AccountShare share = new AccountShare();
				share.AccountId = a.ID;
				share.AccountAccessLevel = 'Read';
				share.UserOrGroupId = uRole.ID;
				//share.RowCause = 'Manual';
				accountShares.add(share);
			}
		}
	}
	Database.insert(accountShares, false);
}