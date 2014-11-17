public class SensisResponse
{
	public Integer code
	{
		get;
		set;
	}

	public String message
	{
		get;
		set;
	}

	public List<Results> results
	{
		get;
		set;
	}

	public Integer count
	{
		get;
		set;
	}

	public String CurrentPage
	{
		get;
		set;
	}

	public String TotalPages
	{
		get;
		set;
	}

	public String TotalResults
	{
		get;
		set;
	}

	public static SensisResponse parse(String json) 
	{
		return (SensisResponse)System.JSON.deserialize(json, SensisResponse.class);
	}

	public class Results 
	{
		public String id
		{
			get;
			set;
		}
		public String Name
		{
			get;
			set;
		}

		public List<Categories> categories
		{
			get;
			set;
		}

		public List<PrimaryContacts> primaryContacts
		{
			get;
			set;
		}

		public PrimaryAddress primaryAddress
		{
			get;
			set;
		}

		public Double distance
		{
			get;
			set;
		}

		public Decimal RoundedDistance
		{
			get
			{
				if(distance == null)
				{
					return null;
				}
				return Decimal.valueOf(distance).setScale(1);
			}
		}
		
		public String Address
		{
			get
			{
				if(primaryAddress == null)
				{
					return '';
				}
				return (String.isBlank(primaryAddress.addressLine) ? '' : (primaryAddress.addressLine + ' '))  + primaryAddress.Suburb;
			}
		}

		public String MapAddress
		{
			get
			{
				return String.isBlank(Address) ? '' : (Address + ',' + primaryAddress.state);
			}
		}
		
		public String ContactNumber
		{
			get
			{
				if(primaryContacts == null)
				{
					return '';
				}
				for(PrimaryContacts pc : primaryContacts)
				{
					if(pc.Type == 'PHONE')
					{
						return pc.value;
					}
				}
				return '';
			}
		}

		public Business__c Business
		{
			get;
			set;
		}
	}

	public class Categories 
	{
		public String id
		{
			get;
			set;
		}
		public String name
		{
			get;
			set;
		}
	}

	public class PrimaryAddress 
	{
		public String state
		{
			get;
			set;
		}

		public String type
		{
			get;
			set;
		}

		public String postcode
		{
			get;
			set;
		}

		public String suburb
		{
			get;
			set;
		}

		public String longitude
		{
			get;
			set;
		}

		public String latitude
		{
			get;
			set;
		}

		public String addressLine
		{
			get;
			set;
		}
		
		public Boolean mappable
		{
			get;
			set;
		}
	}

	public class PrimaryContacts 
	{
		public String type
		{
			get;
			set;
		}

		public String value
		{
			get;
			set;
		}
	}
}