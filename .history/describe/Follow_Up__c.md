2014-11-27 13:22:34
```java
Follow_Up__c Describe:
----------------------------------------------------------------------------------------------------
Total Fields: 	25
----------------------------------------------------------------------------------------------------
Label                                   Name                                    Type                          Length    
------------------------------------------------------------------------------------------------------------------------
Actioned                                Actioned__c                             datetime                                
Address Confirmed                       Address_Confirmed__c                    boolean                                 
Assigned To                             Assigned_To__c                          reference                     18        
Contact Number                          Contact_Number__c                       Formula(string)               1300      
Created By ID                           CreatedById                             reference                     18        
Created Date                            CreatedDate                             datetime                                
Deleted                                 IsDeleted                               boolean                                 
Due Date                                Due_Date__c                             datetime                                
Email                                   Email__c                                Formula(string)               1300      
Employer                                Employer__c                             Formula(string)               1300      
Employer Contact                        Employer_Contact__c                     reference                     18        
Employer Contact  Person                Employer_Contact_Person__c              Formula(string)               1300      
Employer Contact Position               Employer_Contact_Position__c            Formula(string)               1300      
Follow Up ID                            Name                                    string                        80        
Interview Date                          Interview_Date__c                       Formula(date)                           
Interview Result                        Interview_Result__c                     picklist                      255       
Interview Time                          Interview_Time__c                       Formula(string)               1300      
Job Seeker                              Job_Seeker__c                           reference                     18        
Last Modified By ID                     LastModifiedById                        reference                     18        
Last Modified Date                      LastModifiedDate                        datetime                                
Meeting Result                          Meeting_Result__c                       picklist                      255       
Meeting Time                            Meeting_Time__c                         Formula(datetime)                       
Record ID                               Id                                      id                            18        
System Modstamp                         SystemModstamp                          datetime                                
Type                                    Type__c                                 picklist                      255       

----------------------------------------------------------------------------------------------------
Record Type Info: 	1
----------------------------------------------------------------------------------------------------
Available Name                               Default        Recordtypeid        
--------------------------------------------------------------------------------
True      Master                             True           012000000000000AAA  

----------------------------------------------------------------------------------------------------
ChildRelationships Info: 	15
----------------------------------------------------------------------------------------------------
Relationshipname              Cascadedelete                 Field                         Childsobject                  
------------------------------------------------------------------------------------------------------------------------
AttachedContentDocuments      True                          LinkedEntityId                AttachedContentDocument       
Attachments                   True                          ParentId                      Attachment                    
CombinedAttachments           True                          ParentId                      CombinedAttachment            
                              True                          RelatedRecordId               ContentDistribution           
                              True                          LinkedEntityId                ContentDocumentLink           
                                                            FirstPublishLocationId        ContentVersion                
FeedSubscriptionsForEntity    True                          ParentId                      EntitySubscription            
                                                            ParentId                      FeedComment                   
                              True                          ParentId                      FeedItem                      
Histories                     True                          ParentId                      Follow_Up__History            
Notes                         True                          ParentId                      Note                          
NotesAndAttachments           True                          ParentId                      NoteAndAttachment             
ProcessInstances              True                          TargetObjectId                ProcessInstance               
ProcessSteps                                                TargetObjectId                ProcessInstanceHistory        
TopicAssignments              True                          EntityId                      TopicAssignment               


```

