// Create a foursquare ruleset
ruleset foursquare {
	meta {
		name "Foursquare"
		description <<
			Lab 5: Foursquare Checkin Exercise
		>>
		author "Jessica"
		logging off
		
		use module a169x701 alias CloudRain
 		use module a41x186  alias SquareTag
	}
	
	// Listen for "foursquare checkin" event
 	rule process_fs_checkin is active {
 		select when foursquare checkin
 		// store venue name, city, shout, and createdAt event attributes in entity variables
 		pre {
			// extract values from event
			venue_name = event:attr("venue");
			city = event:attr("city");
			shout = event:attr("shout");
			createdAt = event:attr("createdAt");
 		}
 		//noop();
 		replace_inner("#event", event);
		fired {
			mark ent:venue_name with venue_name;
			mark ent:city with city;
			mark ent:shout with shout;
			mark ent:created with createdAt;
		}
 	}
 	
 	// Shows checkin results in SquareTag
 	rule display_checkin {
 		select when web cloudAppSelected
 		pre {
			venue_name = current ent:venue_name;
			city = current ent:city;
			shout = current ent:shout;
			created = current ent:created;
 		
			html = <<
				<h3>Checkin</h3>
				<div id="event"></div>
				<div>Venue: <text id="venue_name" /></div>
				<div>City: <text id="city" /></div>
				<div>Shout: <text id="shout" /></div>
				<div>Created: <text id="created" /></div>
			>>;
 		}
 		{
 			SquareTag:inject_styling();
 			CloudRain:createLoadPanel("Foursquare Checkin", {}, html);
 			replace_inner("#venue_name", venue_name);
 			replace_inner("#city", city);
 			replace_inner("#shout", shout);
 			replace_inner("#created", created);
 		}
 	}
}
