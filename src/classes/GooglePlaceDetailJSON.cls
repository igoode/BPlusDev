public class GooglePlaceDetailJSON 
{
	public List<Html_attributions> html_attributions;
	public String status;
	public Result result;



public class Html_attributions {

}

public class Photos {
	public Integer height;
	public String photo_reference;
	public Integer width;
	public List<Html_attributions> html_attributions;
}

public class Aspects {
	public Integer rating;
	//public String type;
}

public class Reviews {
	public List<Aspects> aspects;
	public Integer x_time;
	public Integer rating;
	public String author_url;
	public String profile_photo_url;
	public String text;
	public String language;
	public String author_name;
}

public class Location {
	public Decimal lat;
	public Decimal lng;
}

public class Geometry {
	public Location location;
}

public class Address_components {
	public String short_name;
	public String long_name;
	//public List<x_Types> x_types;
}

public class Result {
	public String icon;
	public String reference;
	public List<Photos> photos;
	public String url;
	public String adr_address;
	public String vicinity;
	public List<Reviews> reviews;
	public Geometry geometry;
	public String id;
	public String formatted_address;
	public Integer utc_offset;
	public Integer user_ratings_total;
	public String international_phone_number;
	public Decimal rating;
	public String website;
	public String scope;
	public List<Address_components> address_components;
	public String formatted_phone_number;
	public String place_id;
	//public List<Types> types;
	public String name;
}



public static GooglePlaceDetailJSON parse(String jsonStr) {
	return (GooglePlaceDetailJSON) JSON.deserialize(jsonStr, GooglePlaceDetailJSON.class);
}


/*static testMethod void testParse() {
	String json = '{"html_attributions": [], "status": "OK", "result": {"icon": "https://maps.gstatic.com/mapfiles/place_api/icons/generic_business-71.png", "reference": "CmRaAAAA5PyZ2KTBPwL1Pvp5h_MV4yrFJaY2slIS0tLQrjw6CwFy37zwh14FTOqKSZiKNxlCQqEZc9RN35glcFD0rpoK7PaRsfnT9xEiek7A69jatKHxlnsGqqw3I465cxSGaRBUEhB8r0mOpGTZsqWVtNBLWbjBGhTKRRmKKkVi8OTlddzbo8uDdnt1HQ", "photos": [{"height": 960, "photo_reference": "CmRdAAAA0OMsflovILuTLFtawEgnboZQ_dEA4xSofUhziCHW5_yD3Y9hj0Tte_p3o5gjjibLzuHEmMoc4XLO4APhFYg0YZIH0_Cy2AP7ccXrOmjKZbpk5tAU-tgyNaenOmKPzrzKEhAWOJo-6501Nqip9kHoBjafGhRRp8h-aLh3-l8Zg2byLuH_qhYiIA", "width": 1280, "html_attributions": ["<a href=\"https://maps.google.com/maps/contrib/100919424873665842845/photos\">Donnie Piercey</a>"]}, {"height": 1365, "photo_reference": "CmRdAAAAyYFU9rQEE1hjM_XvBecOR9E_C6ObbHWloCm3HpoBYyUPXTV0oyfPjkAiC8NUYgUqodran50vVrGU9DeaBFKz6MdDUfL3kGZKDjJmFX6JRONqaqpnLNRl_r9yozVo4l_hEhDkjbgSWtRZ-MTFfFV6VRl6GhT8ISSTVuF6R79-fmsIHcaG8ycCuA", "width": 2048, "html_attributions": ["<a href=\"https://maps.google.com/maps/contrib/105932078588305868215/photos\">Maksym Kozlenko</a>"]}, {"height": 2368, "photo_reference": "CmRdAAAAcmP54wN3VMPIRQ25-khjoBJRJqIavj_uNYvBU7Ehn7s2YOllQCgSf1l_NY38z0rj327v5MkgUEZddGGV2v3Xc3OvKlwUD2o29SNVatb2_uxzRuWcY2G3u6XHyU6KX_o5EhBDhMNqNFOvBqr6kq6-k1CHGhQ0VN5Re8F6vQsT6yxJ5fHPv9371g", "width": 3200, "html_attributions": ["<a href=\"https://maps.google.com/maps/contrib/108508601154030859314/photos\">Leo Angelo George</a>"]}, {"height": 1131, "photo_reference": "CmRdAAAAfESsVrejYAglTElDZZYZaeK9RtpqSEdw-UaZetqIMs_f8YYkWcqGtvzMAZa9EctV8_v_MKuS-gq09OFSa4WWbWI0GMG5QiNAlcUfMzBqD1VGuax9hD7ImX0zADodzca3EhDGd-QVSuJX6aR5K-fAMrG0GhTXyL2s1w3XjmDtdoL7yJzJfg-YTQ", "width": 1600, "html_attributions": ["<a href=\"https://maps.google.com/maps/contrib/105637462841200316207/photos\">Jemma Tan</a>"]}, {"height": 1536, "photo_reference": "CmRdAAAAt_YtX1i1a7GqlgHZ6MZyU8voPM1Z4bIQjT_dO__V7QONKcMNqHNpYX3QWYu3rZoFCZ42SETo_oxLlSvrEIRENT3sIo6rBdBlVXNSHILesHmEGzDNBWLD_CuaeuOISquaEhAEP_Bs7vqZrsw7QXAWxfmVGhSLAt5syOVBJCcdHOqUrj01P5cJ3Q", "width": 2048, "html_attributions": ["<a href=\"https://maps.google.com/maps/contrib/104177669626132953795/photos\">Justine OBRIEN</a>"]}, {"height": 608, "photo_reference": "CmRdAAAAqv16HOb7d_GyJeFR0Bvs8L57egIF_H1FUEZe4pphVVk1vq-LWEqFQeUH0F-B_WEN-1LJaQn7o5_-yOsBQ7hcJAn9qptOTO5zreTSkh3nHzkFZ3p9Hd2Kb_hgXPnwx_jjEhBe_UmfoAAOtFb1jl7ASDV9GhTH0mNoFUangW8f0_CUlkHP7uQ63A", "width": 1080, "html_attributions": ["<a href=\"https://maps.google.com/maps/contrib/116750797999944764767/photos\">Jessica Pfund</a>"]}, {"height": 2184, "photo_reference": "CmRdAAAAN3lSgjLiaH-1QTYyqKehP3LzIYKqYQFmOIUCPQ1-24VmsFR_cAMFsLQROv8td9QSQXZHoyIbzAHzsNiql8okun-xpaZjve0-4x3h7aNZkWWXqAaeUbXDw8WxrdYBsQ7ZEhCv4OgrY8Q-u1hsniqLXQqbGhStId8fIMhrGZkvK5bmy8_Qm68NhQ", "width": 2911, "html_attributions": ["<a href=\"https://maps.google.com/maps/contrib/114701241123617315548/photos\">Margaret Lee</a>"]}, {"height": 612, "photo_reference": "CmRdAAAAlPzOQoGuiCEbCoB5pG6Y0XXMr4UkOPY1VVUjwHmOnQoD1hGheshaUZhZXdShAXLqZ8TkeLqe3NsGJQCEwykjPosLuAf09B8LjDAf7eATjXAYaNI7kDDU63WCUJzXdWqYEhAtnulA3dFwZi2MnbvTgtdLGhTHZCAPPSxMAULbHLJz9wgmmRTTlQ", "width": 816, "html_attributions": ["<a href=\"https://maps.google.com/maps/contrib/114701241123617315548/photos\">Margaret Lee</a>"]}, {"height": 3024, "photo_reference": "CmRdAAAAMjTCx-TnLHWrrZZqGdCTJ-zCmznYeiIZLDNwJZDoFYGvA0r3bH02G1oxLVzfJqyfjKX7Zrk7TgvKoHpRxM7_U6YHB5e2UHko75ou0_wfZYD_en4oOGpIXxWet2NxuknlEhCwKPouu_LiTih1SJHnBL86GhT0SDwlWXWoohYr5-_3bulzO4c3bA", "width": 4032, "html_attributions": ["<a href=\"https://maps.google.com/maps/contrib/102558609090086310801/photos\">Huy Tran</a>"]}, {"height": 1224, "photo_reference": "CmRdAAAA5ZD7MQPUQ9ci05L3fqErt0tgoFL6_tKTIN3gTS25mwYQeH3vfm4hJEm0U5LgwxeCg9L2jFC46S_79xv7MbstVQYEEcEfNNBxy7jTLPgu-bdIaQelj_Sa441_UA0En6I5EhCJLQBW4AdEHD3v_Lxsl-M3GhQ3aYBThzGR2TmX_qdSFBHGUl0tDQ", "width": 1632, "html_attributions": ["<a href=\"https://maps.google.com/maps/contrib/102793072679802771755/photos\">Keith Denny</a>"]}], "url": "https://maps.google.com/?cid=10281119596374313554", "adr_address": "5, <span class=\"street-address\">48 Pirrama Rd</span>, <span class=\"locality\">Pyrmont</span> <span class=\"region\">NSW</span> <span class=\"postal-code\">2009</span>, <span class=\"country-name\">Australia</span>", "vicinity": "5 48 Pirrama Road, Pyrmont", "reviews": [{"aspects": [{"rating": 3, "type": "overall"}], "time": 1451482843, "rating": 5, "author_url": "https://plus.google.com/104177669626132953795", "profile_photo_url": "//lh6.googleusercontent.com/-s6AzNe5Qcco/AAAAAAAAAAI/AAAAAAAAFTE/NvVzCuI-jMI/photo.jpg", "text": "Google Sydney is located on Darling Island on the glorious Sydney Harbour in a prime position easy to get to for staff and visitors. The reception has an excellent fresh living wall and the staff are welcoming, pleasant and friendly, ready to assist you with bountiful information for all inquiries. All ready to *do the right thing* Always helping *Go Get IT*, the right information to *Gather IT*, from all the right places plus *Give IT* at all the right times to all the right people! \nGo Get Gather Give Google excellence personified at Google Sydney! Thanks Google Sydney!", "language": "en", "author_name": "Justine OBRIEN"}, {"aspects": [{"rating": 3, "type": "overall"}], "time": 1455632820, "rating": 5, "author_url": "https://plus.google.com/100482974853389838438", "profile_photo_url": "//lh3.googleusercontent.com/-95MwIKSvGhw/AAAAAAAAAAI/AAAAAAAAMI0/SDn7W1qL2nI/photo.jpg", "text": "The Google Office is an amazing space inside this building. You are great with an awesome reception area on level 5 and if you're lucky you'll get to meet Basil the parrot (owned by the super friendly receptionist Luke). It's a great office space with nice meeting rooms. Google has very friendly baristas on Level 4 serving coffees from 8.30am to 3.30pm to Googlers and their visitors. The cafe on Level 6 (top floor) serves great breakfast, lunch and dinner with healthy salads, fresh squeeze-your-own juices and the best thing is a spectacular view of the Sydney Harbor Bridge in the distance.", "language": "en", "author_name": "Mark Vozzo"}, {"aspects": [{"rating": 3, "type": "overall"}], "time": 1456171339, "rating": 5, "author_url": "https://plus.google.com/112352616160601092271", "profile_photo_url": "//lh5.googleusercontent.com/-RLMS0wL2avs/AAAAAAAAAAI/AAAAAAAAtLU/dRAbmewWhXs/photo.jpg", "text": "One of my favourite Google offices! It overlooks the Darling harbour, and you can have the best lunch overlooking the harbour. The office is colourful, fun and everyone is friendly. ", "language": "en", "author_name": "Wii Lu"}, {"aspects": [{"rating": 3, "type": "overall"}], "time": 1455988590, "rating": 5, "author_url": "https://plus.google.com/104922001665742539850", "profile_photo_url": "//lh3.googleusercontent.com/-SsHpPJdyPnI/AAAAAAAAAAI/AAAAAAABUWQ/t_D7jU7enwA/photo.jpg", "text": "If your lucky your will meet talking parrot at the reception. If you have time, get a coffee from 4th barista Tanya", "language": "en", "author_name": "Jan Gemrich"}, {"aspects": [{"rating": 0, "type": "overall"}], "time": 1456990769, "rating": 1, "author_url": "https://plus.google.com/114746545364501357372", "text": "It is really disappointing when you phone google for assistance with their online reviews, due to defamation and they send you in circles and never give you an answer. Really disappointing ", "language": "en", "author_name": "Karl Jo"}], "geometry": {"location": {"lat": -33.8666113, "lng": 151.1958324}}, "id": "4f89212bf76dde31f092cfc14d7506555d85b5c7", "formatted_address": "5, 48 Pirrama Rd, Pyrmont NSW 2009, Australia", "utc_offset": 660, "user_ratings_total": 138, "international_phone_number": "+61 2 9374 4000", "rating": 4.5, "website": "https://www.google.com.au/about/careers/locations/sydney/", "scope": "GOOGLE", "address_components": [{"short_name": "5", "long_name": "5", "types": ["floor"]}, {"short_name": "48", "long_name": "48", "types": ["street_number"]}, {"short_name": "Pirrama Rd", "long_name": "Pirrama Road", "types": ["route"]}, {"short_name": "Pyrmont", "long_name": "Pyrmont", "types": ["locality", "political"]}, {"short_name": "NSW", "long_name": "New South Wales", "types": ["administrative_area_level_1", "political"]}, {"short_name": "AU", "long_name": "Australia", "types": ["country", "political"]}, {"short_name": "2009", "long_name": "2009", "types": ["postal_code"]}], "formatted_phone_number": "(02) 9374 4000", "place_id": "ChIJN1t_tDeuEmsRUsoyG83frY4", "types": ["point_of_interest", "establishment"], "name": "Google"}}';
	JSON2Apex obj = parse(json);
	System.assert(obj != null);
}*/
}