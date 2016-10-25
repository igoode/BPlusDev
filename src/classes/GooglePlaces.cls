public class GooglePlaces 
{ 
    public GooglePlacesJSON placeJson
    {
        get;
        set;
    }

    public static Location getLocation(String businesslocation)
    {
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        String key = Test.isRunningTest() ? 'test' : Google_Places__c.getOrgDefaults().Geolocation_API_Key__c;
        request.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?address=' + EncodingUtil.urlEncode(businesslocation, 'UTF-8') + '&key=' + key);
		if(!Test.isRunningTest())
		{
			HttpResponse response = (new Http()).send(request);
			GoogleGeocodingJSON geoJSON = GoogleGeocodingJSON.parse(response.getBody());
			for(GoogleGeocodingJSON.Results geoResult : geoJSON.Results)
			{
				return Location.newInstance(geoResult.geometry.location.lat, geoResult.geometry.location.lng);
			}
		}
        return Test.isRunningTest() ? Location.newInstance(1.0, 1.0) : null;
    }

    public static GooglePlacesJSON search(String keyword, String radius, String searchlocation, String latLong)
    {
		if (String.isBlank(latLong))
		{
			Location loc = getLocation(searchlocation);
			latLong = String.valueOf(loc.getLatitude()) + ',' + String.valueOf(loc.getLongitude());
		}
        //String endPoint = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
		String endPoint = 'https://maps.googleapis.com/maps/api/place/textsearch/json';
		String key = Test.isRunningTest() ? 'test' : Google_Places__c.getOrgDefaults().Places_API_Key__c;
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(endPoint + '?query=' + EncodingUtil.urlEncode(keyword + ' in '+ searchlocation, 'UTF-8') + '&location=' + latLong + '&rankby=distance&key=' + key);
		if(Test.isRunningTest())
		{
			return new GooglePlacesJSON();	
		}
		HttpResponse response = (new Http()).send(request);
		return GooglePlacesJSON.parse(response.getBody());
    }

	public static void getDetail(Business__c employer, Employer_Contact__c ec)
    {
        String endPoint = 'https://maps.googleapis.com/maps/api/place/details/xml';
		String key = Google_Places__c.getOrgDefaults().Places_API_Key__c;
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(endPoint + '?placeid=' + employer.Google_Place_ID__c + '&key=' + key);
		HttpResponse response = (new Http()).send(request);
		Dom.Document doc = response.getBodyDocument();
		Dom.XMLNode rootNode =  response.getBodyDocument().getRootElement(); 
		Dom.XMLNode resultNode = rootNode.getChildElement('result', null);
		employer.Address__c = resultNode.getChildElement('formatted_address', null).getText();
		ec.Address__c = employer.Address__c;
		if (resultNode.getChildElement('website', null) != null)
		{
			employer.Website__c = resultNode.getChildElement('website', null).getText();
		}
		employer.Phone__c = resultNode.getChildElement('formatted_phone_number', null).getText();
		ec.Contact_Number__c = employer.Phone__c;
		if (employer.LatLong__c == null)
		{
			Dom.XMLNode locationNode = resultNode.getChildElement('geometry', null).getChildElement('location', null);
			String lat = locationNode.getChildElement('lat', null).getText();
			String lng = locationNode.getChildElement('lng', null).getText();

		}
    }

	private static String removeSpecialCharacters(String s)
	{
		return s == null ? null : s.replaceAll('"\\u003ca', '"').replaceAll('"\\u003e', '"').replaceAll('"\\u003c', '"');
	}
}