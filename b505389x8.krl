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
 		}
 		noop();
 		fired {
			mark ent:location with location;
		}
	}
	
	rule location_show is active {
	 	select when web cloudAppSelected
 		pre {
			info = current ent:location;
			checkin = info.decode();
			venue_name = checkin.pick("$..venue.name");
			city = checkin.pick("$..location.city");
			shout = checkin.pick("$..shout", true).head();
			createdAt = checkin.pick("$..createdAt");
 		
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
 			CloudRain:createLoadPanel("Foursquare Checkin (Lab 8)", {}, html);
 			replace_inner("#venue_name", venue_name);
 			replace_inner("#city", city);
 			replace_inner("#shout", shout);
 			replace_inner("#created", createdAt);
 		}
	}
}
