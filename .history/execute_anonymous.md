2014-11-21 16:35:04
```java
SensisSearchController s = new SensisSearchController();
s.sendReport();
```

2014-11-21 16:35:56
```java
SensisSearchController s = new SensisSearchController();
s.sendReport();
```

2014-11-21 16:37:02
```java
SensisSearchController s = new SensisSearchController();
s.sendReport();
```

2014-11-21 16:37:51
```java
SensisSearchController s = new SensisSearchController();
s.sendReport();
```

2014-11-21 16:38:24
```java
SensisSearchController s = new SensisSearchController();
s.sendReport();
```

2014-11-21 16:47:01
```java
SensisSearchController s = new SensisSearchController();
s.sendReport();
```

2014-11-21 16:47:52
```java
SensisSearchController s = new SensisSearchController();
s.sendReport();
```

2014-11-21 16:51:19
```java
SensisSearchController s = new SensisSearchController();
s.sendReport(122345);
```

2014-11-21 16:51:31
```java
SensisSearchController s = new SensisSearchController();
s.sendReport('122345');
```

2014-11-21 16:55:49
```java
SensisSearchController s = new SensisSearchController();
s.sendReport('122345');
```

2014-11-25 15:50:32
```java
system.debug('a' > 'b');
```

2014-11-25 15:50:43
```java
system.debug('a' < 'b');
```

2014-11-25 15:50:54
```java
system.debug('A' < 'b');
```

2014-11-25 15:51:08
```java
system.debug('A' < 'a');
```

2014-11-25 15:51:21
```java
system.debug('A' <= 'a');
```

2014-11-25 15:51:30
```java
system.debug('A' == 'a');
```

2014-11-26 11:24:41
```java
List<Job_Industry__c> ji = new List<Job_Industry__c>();
for(Job__c job : [SELECT ID, Name,
                                    Industry1__c, 
                                    Industry2__c,
                                    Industry3__c,
                                    Industry4__c,
                                    Industry5__c
                             FROM   Job__c])
{
	if(job.Industry1__c != null)
	{
		Job_Industry__c j = new Job_Industry__c(Job__c = job.ID, Industry__c = job.Industry1__c);
		ji.add(j);
	}
	if(job.Industry2__c != null)
	{
		j = new Job_Industry__c(Job__c = job.ID, Industry__c = job.Industry2__c);
		ji.add(j);
	}
	if(job.Industry3__c != null)
	{
		j = new Job_Industry__c(Job__c = job.ID, Industry__c = job.Industry3__c);
		ji.add(j);
	}
	if(job.Industry4__c != null)
	{
		j = new Job_Industry__c(Job__c = job.ID, Industry__c = job.Industry4__c);
		ji.add(j);
	}
	if(job.Industry5__c != null)
	{
		j = new Job_Industry__c(Job__c = job.ID, Industry__c = job.Industry5__c);
		ji.add(j);
	}
}
insert ji;
```

2014-11-26 11:25:04
```java
List<Job_Industry__c> ji = new List<Job_Industry__c>();
Job_Industry__c j;
for(Job__c job : [SELECT ID, Name,
                                    Industry1__c, 
                                    Industry2__c,
                                    Industry3__c,
                                    Industry4__c,
                                    Industry5__c
                             FROM   Job__c])
{
	if(job.Industry1__c != null)
	{
		j = new Job_Industry__c(Job__c = job.ID, Industry__c = job.Industry1__c);
		ji.add(j);
	}
	if(job.Industry2__c != null)
	{
		j = new Job_Industry__c(Job__c = job.ID, Industry__c = job.Industry2__c);
		ji.add(j);
	}
	if(job.Industry3__c != null)
	{
		j = new Job_Industry__c(Job__c = job.ID, Industry__c = job.Industry3__c);
		ji.add(j);
	}
	if(job.Industry4__c != null)
	{
		j = new Job_Industry__c(Job__c = job.ID, Industry__c = job.Industry4__c);
		ji.add(j);
	}
	if(job.Industry5__c != null)
	{
		j = new Job_Industry__c(Job__c = job.ID, Industry__c = job.Industry5__c);
		ji.add(j);
	}
}
insert ji;
```

2015-02-17 10:31:38
```java
List<String>listingIDs = new List<String>{'abc','def','ghi'};
system.debug(listingIDs.join('&id='));
```

2015-02-17 10:31:49
```java
List<String>listingIDs = new List<String>{'abc','def','ghi'};
system.debug(listingIDs.join());
```

2015-02-17 10:32:57
```java
List<String>listingIDs = new List<String>{'abc','def','ghi'};
system.debug(String.join(listingIDs, '&id=');
```

2015-02-17 10:33:09
```java
List<String>listingIDs = new List<String>{'abc','def','ghi'};
system.debug(String.join(listingIDs, '&id='));
```

2015-02-17 10:38:10
```java
List<String>listingIDs = new List<String>{'abc','def','ghi'};
system.debug('&id=' + String.join(listingIDs, '&id='));
```

2015-02-17 10:38:36
```java
List<String>listingIDs = new List<String>{'abc'};
system.debug('&id=' + String.join(listingIDs, '&id='));
```

