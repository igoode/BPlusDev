public class GoogleGeocodingJSON 
{ 
public List<Results> results;
	public String status;
public class Address_components {
	//public List<Types> types;
	public String long_name;
	public String short_name;
}

public class Northeast {
	public Decimal lat;
	public Decimal lng;
}

public class Southwest {
	public Decimal lat;
	public Decimal lng;
}

public class Viewport {
	public Northeast northeast;
	public Southwest southwest;
}

public class Location {
	public Decimal lat;
	public Decimal lng;
}

public class Geometry {
	public Viewport viewport;
	public Location location;
	public String location_type;
}

public class Results {
	public List<Address_components> address_components;
	public Geometry geometry;
	public String place_id;
	public String formatted_address;
	//public List<Types> types;
}


public static GoogleGeocodingJSON parse(String jsonStr) {
	return (GoogleGeocodingJSON)JSON.deserialize(jsonStr, GoogleGeocodingJSON.class);
}

/*static testMethod void testParse() {
	String json = '{"results": [{"address_components": [{"types": ["street_number"], "long_name": "1600", "short_name": "1600"}, {"types": ["route"], "long_name": "Amphitheatre Pkwy", "short_name": "Amphitheatre Pkwy"}, {"types": ["locality", "political"], "long_name": "Mountain View", "short_name": "Mountain View"}, {"types": ["administrative_area_level_2", "political"], "long_name": "Santa Clara County", "short_name": "Santa Clara County"}, {"types": ["administrative_area_level_1", "political"], "long_name": "California", "short_name": "CA"}, {"types": ["country", "political"], "long_name": "United States", "short_name": "US"}, {"types": ["postal_code"], "long_name": "94043", "short_name": "94043"}], "geometry": {"viewport": {"northeast": {"lat": 37.4238253802915, "lng": -122.0829009197085}, "southwest": {"lat": 37.4211274197085, "lng": -122.0855988802915}}, "location": {"lat": 37.4224764, "lng": -122.0842499}, "location_type": "ROOFTOP"}, "place_id": "ChIJ2eUgeAK6j4ARbn5u_wAGqWA", "formatted_address": "1600 Amphitheatre Parkway, Mountain View, CA 94043, USA", "types": ["street_address"]}], "status": "OK"}';
	JSON2Apex obj = parse(json);
	System.assert(obj != null);
*/
}