2014-11-25 15:56:02
```java
SELECT ID, 
                                        Name,
                                        Initial__c
                                FROM    Industry__c
                                WHERE   Initial__c >= 'A' AND Initial__c <='F'
                                ORDER BY Name
```

2014-11-26 09:48:48
```java
SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Job_Seeker__c, 
Delivered__c, Gateway_Reference__c, Message__c, Number__c, Sent__c, Type__c FROM SMS_Notification__c
ORDER BY CreatedDate DESC
```

2014-11-26 09:52:32
```java
SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Job_Seeker__c, 
Delivered__c, Gateway_Reference__c, Message__c, Number__c, Sent__c, Type__c FROM SMS_Notification__c
ORDER BY CreatedDate DESC
```

2014-11-26 11:30:12
```java
SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Job__c, Industry__c, Job_Name__c, Industry_Name__c, Industry_Sensis_Category_ID__c FROM Job_Industry__c
```

2014-11-27 10:51:50
```java
SELECT Id, 
                                        Name, 
                                        Username, 
                                        LastName, 
                                        FirstName, 
                                        Title, 
                                        Email, 
                                        Alias, 
                                        IsActive, 
                                        ProfileId, 
                                        UserType, 
                                        ContactId, 
                                        Contact.AccountID,
                                        AccountId
                                FROM    User
```

2014-11-27 13:42:34
```java
SELECT 	ID,
									PortalAccountId
							FROM 	UserRole
							WHERE 	PortalAccountId != null
```

2014-11-28 14:45:49
```java
SELECT Profile.Name FROM User
```

2014-12-05 17:22:20
```java
SELECT ID, Name,CreatedDate, CreatedBy.NAme
FROM   Job_Seeker__c
order by name
```

