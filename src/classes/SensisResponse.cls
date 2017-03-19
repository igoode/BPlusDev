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

	public List<String> ValidationErrors 
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
		
		public String reportingId
		{
			get;
			set;
		}

		public String GooglePlacesId
		{
			get;
			set;
		}

		public String Name
		{
			get;
			set;
		}

        public String ABN
        {
            get
            {
                return businessInfo == null ? null : businessInfo.abn;
            }
        }

		public String Category 
		{
			get
			{
				String s = '';
				if(categories == null)
				{
					return s;
				}
				for(Categories c : categories)
				{
					s += c.Name + ',';
				}
				return s.removeEnd(',');
			}
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

        public BusinessInfo businessInfo
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

		public String WebSite 
		{
			get
			{
				if(primaryContacts != null)
				{
					for(PrimaryContacts pc : primaryContacts)
					{
						if(pc.Type == 'URL')
						{
							return pc.value;
						}
					}
				}
				return 'https://www.google.com.au/?q=' + Name + ' ' + Suburb + '&gws_rd=ssl#newwindow=1&safe=off&q=' + Name;
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

		public String Suburb 
		{
			get
			{
				if(primaryAddress == null)
				{
					return '';
				}
				return primaryAddress.suburb;
			}
		}


		public String MapAddress
		{
			get
			{
				if(String.isBlank(Address))
				{
					return '';
				}
                if(String.isBlank(GooglePlacesId))
                {
                    if(String.isBlank(primaryAddress.state))
                    {
                        return Address;
                    }
                    return Address + ',' + primaryAddress.state;
                }
                else
                {
                    return Address;
                }
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
					if(pc.Type == 'PHONE' || pc.Type == 'MOBILE')
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

    public class BusinessInfo
    {
        public String abn
        {
            get;
            set;
        }
    }

	public static SensisResponse convertFromGooglePlaces(GooglePlacesJSON placesJSON, String searchLatLng, Integer radius)
	{
		SensisResponse response = new SensisResponse();
		if(String.isBlank(searchLatLng))
		{
			throw new BPException('Search location could not be determined. Use the format "Sydney NSW"');
		}
		String[] latLng = searchLatLng.split(',');
		Location searchLocation = Location.newInstance(Decimal.valueOf(latLng[0]), Decimal.valueOf(latLng[1]));
		response.count = placesJSON.Results.size();
		response.Results = new List<SensisResponse.Results>();
		for(GooglePlacesJSON.results gResult : placesJSON.Results)
		{
			SensisResponse.Results sResult = new SensisResponse.Results();
			sResult.PrimaryAddress = new SensisResponse.PrimaryAddress();
			sResult.GooglePlacesId = gResult.place_Id;
			sResult.Name = gResult.name;
			sResult.primaryAddress.Suburb = '';//gResult.vicinity;
            sResult.primaryAddress.addressLine = gResult.formatted_address;
			if(gResult.geometry.location.lng != null && gResult.geometry.location.lat != null)
			{
				sResult.PrimaryAddress.longitude = String.valueOf(gResult.geometry.location.lng);
				sResult.PrimaryAddress.latitude = String.valueOf(gResult.geometry.location.lat);
				Location l = Location.newInstance(gResult.geometry.location.lat, gResult.geometry.location.lng);
				sResult.distance = l.getDistance(searchLocation, 'km');
				if(sResult.distance > radius * 1000.0)
				{
					continue;
				}
                sResult.distance /= 1000.0;
			}
			response.Results.add(sResult);
		}
		return response;
	}
}