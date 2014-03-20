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
 		//if distance < 5 then
			noop();
 		fired {
			mark ent:o_lat with old_lat;
			mark ent:o_lng with old_lng;
			mark ent:n_lat with new_lat;
			mark ent:n_lng with new_lng;
			
			raise explicit event "location_nearby" with distance = distance;
 		}
	}
	
	rule show_data is active {
 		select when web cloudAppSelected
 		pre {
			lat1 = current ent:o_lat;
			lng1 = current ent:o_lng;
			lat2 = current ent:n_lat;
			lng2 = current ent:n_lng;
 		
			html = <<
				<h3>Nearby</h3>
				<div id="lt1"></div>
				<div id="lg1"></div>
				<div id="lt2"></div>
				<div id="lg2"></div>
			>>;
 		}
 		{
 			SquareTag:inject_styling();
 			CloudRain:createLoadPanel("Distance", {}, html);
 			replace_inner("#lt1", lat1);
 			replace_inner("#lg1", lng1);
 			replace_inner("#lt2", lat2);
 			replace_inner("#lg2", lng2);
 		}
	}
}
