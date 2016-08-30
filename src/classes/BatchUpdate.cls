global class BatchUpdate implements Database.Batchable<SObject>, Database.AllowsCallouts, Database.Stateful
 {
	
	global BatchUpdate() {
		
	}
	
	private static Integer calloutCount = 0;
	/**
	 * @description gets invoked when the batch job starts
	 * @param context contains the job ID
	 * @returns the record set as a QueryLocator object that will be batched for execution
	 */ 
	global Database.QueryLocator start(Database.BatchableContext context) 
	{
		return Database.getQueryLocator([SELECT Id, 
												Name,
												LAtLong__c,
												Sensis_ID__c
										FROM	Business__c
										WHERE	Sensis_ID__c != null AND 
												Has_LatLong__c = false AND 
												LatLong_Error__c = null
										ORDER BY LastModifiedDate
										LIMIT 1]);
	}

	/**
	 * @description gets invoked when the batch job executes and operates on one batch of records. Contains or calls the main execution logic for the batch job.
	 * @param context contains the job ID
	 * @param scope contains the batch of records to process.
	 */ 
   	global void execute(Database.BatchableContext context, List<Business__c> scope) 
	{
		for(Business__c b :  scope)
		{
			try 
			{	        
				SensisSearchController c = new SensisSearchController();
				SensisResponse.Results[] results = c.doSearchByID(b.Sensis_ID__c);
				if(results.isEmpty())
				{
					b.LatLong_Error__c = 'Sensis listing mot found';
					update b;
					continue;
				}
				for(SensisResponse.Results r : results)
				{
					calloutCount++;
					if(r.primaryAddress == null)
                    {
                        b.LatLong_Error__c = 'No address found';
                    }
                    else
					{
						Decimal lat = Decimal.valueOf(r.primaryAddress.latitude);
						Decimal lng = Decimal.valueOf(r.primaryAddress.longitude);
						Location l = Location.newInstance(lat, lng);
						b.LatLong__Longitude__s = lng;
						b.LatLong__Latitude__s = lat;
					}
                    update b;
				}
			}
			catch (Exception  ex)
			{
				b.LatLong_Error__c = ex.getMessage();
				update b;
			}
			
		}
	}
	
	/**
	 * @description gets invoked when the batch job finishes. Place any clean up code in this method.
	 * @param context contains the job ID
	 */ 
	global void finish(Database.BatchableContext context) 
	{
		if (calloutCount >= 5000)
		{
			return;
		}
		BatchUpdate b = new BatchUpdate();
		Google_Places__c settings = Google_Places__c.getInstance();
		System.scheduleBatch(b, 'LatLongUpdate', settings.Batch_Update_Period__c.intValue(), settings.Batch_Update_Size__c.intValue());
	}
}