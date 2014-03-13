ruleset examine_location {
	meta {
		name "Display location"
		description <<
			Lab 6: Data Storage Module
		>>
		author "Jessica"
		logging off
		
 		use module a169x701 alias CloudRain
 		use module a41x186  alias SquareTag
 		// use location_data ruleset as a module
 		//use module b505389x4 alias LocationData
 		use module location_data alias LocationData
	}
	
	global {
	}
	
	// Show last Foursquare checkin
	rule show_fs_location is active {
 		select when web cloudAppSelected
 		pre {
			info = LocationData:get_location_data();
			venue_name = info{"venue"};
			city = info{"city"};
			shout = info{"shout"};
			created = info{"createdAt"};
 		
			html = <<
				<h3>Checkin</h3>
				<div id="event"></div>
				<div>Venue: <text id="venue_name" /></div>
				<div>City: <text id="city" /></div>
				<div>Shout: <text id="shout" /></div>
				<div>Created: <text id="created" /></div>
				<div id="checkin"></div>
			>>;
 		}
 		{
 			SquareTag:inject_styling();
 			CloudRain:createLoadPanel("Foursquare Checkin (Lab 6)", {}, html);
 			replace_inner("#venue_name", venue_name);
 			replace_inner("#city", city);
 			replace_inner("#shout", shout);
 			replace_inner("#created", created);
 		}
	}
	
	// Listens for pds:new_location_data (attributes: key & value)
 	rule add_location_item is active {
 		select when pds new_location_data
 		pre {
			key = event:attr("key");
			event = event:attr("value");
 		}
 		
 		noop();
 		// store the data in the value attribute in a map entity variable
 		// using the value of the key attribute as the key for the map
 		fired {
			set ent:mymap{key} event;
 		}
 	}
}
