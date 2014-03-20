ruleset analyze_location {
	meta {
		name "Anaylze Location"
		description <<
			Lab 7: Event Network Exercise (Semantic Translation)
		>>
		author "Jessica"
		logging off
		
 		use module a169x701 alias CloudRain
 		use module a41x186  alias SquareTag
 		use module b505389x4 alias LocationData
	}
	
	global {
	}
	
	// Listens for the new_current:location event 
	rule nearby is active {
 		select when location new_current
 		pre {
			r90 = math:pi()/2;
			// radius of the Earth in km
			earth_radius = 6378;
 		
			// point a (location of last checkin)
			old_lat = LocationData:get_lat("fs_checkin");
			old_lng = LocationData:get_long("fs_checkin");
			// point b
			new_lat = event:attr("lat");
			new_lng = event:attr("long");
			
			// convert coordinates to radians
			old_lat = math:deg2rad(old_lat);
			old_lng = math:deg2rad(old_lng);
			new_lat = math:deg2rad(new_lat);
			new_lng = math:deg2rad(new_lng);
			
			// calculate distance between new lat/long from old lat/long
			// raise explicit location_nearby if with 5 miles (or some other threshold)
			// raise explicit location_far otherwise
			// -> both events should contain distance as an attribute
			// g_c_d(long1, pi/2 - lat1, long2, pi/2 - lat2, r(opt))
			distance = math:great_circle_distance(old_lng, r90 - old_lat, new_lng, r90 - new_lat, earth_radius);
			
			html = <<
				<h3>Distance</h3>
				<div id="message"></div>
				<div id="distance"></div>
			>>;
 		}
 		{
			raise explicit event "location_nearby" with distance = distance;
 		}
	}
}
