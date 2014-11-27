2014-11-27 13:43:27
```java
UserRole Describe:
----------------------------------------------------------------------------------------------------
Total Fields: 	17
----------------------------------------------------------------------------------------------------
Label                                   Name                                    Type                          Length    
------------------------------------------------------------------------------------------------------------------------
Account ID                              PortalAccountId                         reference                     18        
Case Access Level for Account Owner     CaseAccessForAccountOwner               picklist                      40        
Contact Access Level for Account Owner  ContactAccessForAccountOwner            picklist                      40        
Description                             RollupDescription                       string                        80        
Developer Name                          DeveloperName                           string                        80        
Last Modified By ID                     LastModifiedById                        reference                     18        
Last Modified Date                      LastModifiedDate                        datetime                                
May Forecast Manager Share              MayForecastManagerShare                 boolean                                 
Name                                    Name                                    string                        80        
Opportunity Access Level for Account OwnerOpportunityAccessForAccountOwner        picklist                      40        
Parent Role ID                          ParentRoleId                            reference                     18        
Portal Role                             PortalRole                              picklist                      40        
Portal Type                             PortalType                              picklist                      40        
Role ID                                 Id                                      id                            18        
System Modstamp                         SystemModstamp                          datetime                                
User ID                                 ForecastUserId                          reference                     18        
User ID                                 PortalAccountOwnerId                    reference                     18        

----------------------------------------------------------------------------------------------------
Record Type Info: 	0
----------------------------------------------------------------------------------------------------



----------------------------------------------------------------------------------------------------
ChildRelationships Info: 	6
----------------------------------------------------------------------------------------------------
Relationshipname              Cascadedelete                 Field                         Childsobject                  
------------------------------------------------------------------------------------------------------------------------
                              True                          UserRoleId                    ForecastShare                 
                                                            RelatedId                     Group                         
                                                            UserRoleId                    Name                          
                                                            UserRoleId                    RecentlyViewed                
Users                                                       UserRoleId                    User                          
                                                            ParentRoleId                  UserRole                      


```

