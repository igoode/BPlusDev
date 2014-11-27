2014-11-27 11:52:35
```java
Job_Seeker__c Describe:
----------------------------------------------------------------------------------------------------
Total Fields: 	31
----------------------------------------------------------------------------------------------------
Label                                   Name                                    Type                          Length    
------------------------------------------------------------------------------------------------------------------------
1  Marketable Attribute                 X1_Marketable_Attribute__c              textarea                      255       
2 Marketable Attribute                  X2_Marketable_Attribute__c              textarea                      255       
3 Marketable Attribute                  X3_Marketable_Attribute__c              textarea                      255       
Account                                 Account__c                              reference                     18        
Account Name                            Account_Name__c                         string                        255       
Address Location                        Address_Location__c                     Formula(string)               1300      
Assigned To                             Assigned_To__c                          reference                     18        
Created By ID                           CreatedById                             reference                     18        
Created Date                            CreatedDate                             datetime                                
Deleted                                 IsDeleted                               boolean                                 
Email                                   Email__c                                email                         80        
JSK ID                                  JSK_ID__c                               string                        255       
Last Modified By ID                     LastModifiedById                        reference                     18        
Last Modified Date                      LastModifiedDate                        datetime                                
Last Referenced Date                    LastReferencedDate                      datetime                                
Last Viewed Date                        LastViewedDate                          datetime                                
Length of Experience                    Length_of_Experience__c                 picklist                      255       
Longest job they have held              Longest_experience__c                   picklist                      255       
Marketing Ended                         Marketing_Ended__c                      datetime                                
Marketing Outcome                       Marketing_Outcome__c                    picklist                      255       
Marketing Started                       Marketing_Started__c                    datetime                                
Mobile                                  Mobile__c                               phone                         40        
Name                                    Name                                    string                        80        
Owner ID                                OwnerId                                 reference                     18        
Professional and Specialist Role        Professional_and_Specialist_Role__c     boolean                                 
Qualifications                          Qualifications__c                       multipicklist                 4099      
Record ID                               Id                                      id                            18        
Site and JSK ID                         Site_and_JSK_ID__c                      string                        255       
State                                   State__c                                picklist                      255       
Suburb                                  Suburb__c                               string                        255       
System Modstamp                         SystemModstamp                          datetime                                

----------------------------------------------------------------------------------------------------
Record Type Info: 	1
----------------------------------------------------------------------------------------------------
Available Name                               Default        Recordtypeid        
--------------------------------------------------------------------------------
True      Master                             True           012000000000000AAA  

----------------------------------------------------------------------------------------------------
ChildRelationships Info: 	19
----------------------------------------------------------------------------------------------------
Relationshipname              Cascadedelete                 Field                         Childsobject                  
------------------------------------------------------------------------------------------------------------------------
AttachedContentDocuments      True                          LinkedEntityId                AttachedContentDocument       
Attachments                   True                          ParentId                      Attachment                    
CombinedAttachments           True                          ParentId                      CombinedAttachment            
                              True                          RelatedRecordId               ContentDistribution           
                              True                          LinkedEntityId                ContentDocumentLink           
                                                            FirstPublishLocationId        ContentVersion                
Employer_Contacts__r          True                          Job_Seeker__c                 Employer_Contact__c           
FeedSubscriptionsForEntity    True                          ParentId                      EntitySubscription            
                                                            ParentId                      FeedComment                   
                              True                          ParentId                      FeedItem                      
Follow_Ups__r                                               Job_Seeker__c                 Follow_Up__c                  
Histories                     True                          ParentId                      Job_Seeker__History           
Shares                        True                          ParentId                      Job_Seeker__Share             
Notes                         True                          ParentId                      Note                          
NotesAndAttachments           True                          ParentId                      NoteAndAttachment             
ProcessInstances              True                          TargetObjectId                ProcessInstance               
ProcessSteps                                                TargetObjectId                ProcessInstanceHistory        
SMS_Notifications__r          True                          Job_Seeker__c                 SMS_Notification__c           
TopicAssignments              True                          EntityId                      TopicAssignment               


```

