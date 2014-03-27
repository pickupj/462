ruleset location_notification {
	meta {
		name "Location Notification"
		description <<
			Lab 8: Dispatching Events Exercise
		>>
		author "Jessica"
		logging off
		
		use module a169x701  alias CloudRain
 		use module a41x186   alias SquareTag
	}
	
	// Listens for the location notification event
	rule location_catch is active {
 		select when location notification
 		pre {
			location = event:attr("location");
			y = "location_catch";
 		}
		send_directive("location_catch") with body = "rule fired";
 		fired {
			mark ent:location with location;
			mark ent:y with y;
		}
	}
	
	rule location_show is active {
	 	select when web cloudAppSelected
 		pre {
			info = current ent:location;
			venue_name = info{"venue"};
			city = info{"city"};
			shout = info{"shout"};
			created = info{"createdAt"};
			y = current ent:y;
 		
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
 			CloudRain:createLoadPanel("Location", {}, html);
 			replace_inner("#venue_name", venue_name);
 			replace_inner("#city", city);
 			replace_inner("#shout", shout);
 			replace_inner("#created", created);
 			replace_inner("#checkin", y);
 		}
	}
}
