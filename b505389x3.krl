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
	
	global {
		subscription_1 = { "rids": "b505964x0",
						   "cid":  "10B1719E-B5D4-11E3-9DD4-B1C8E71C24E1"
						 };
		subscription_2 = { "rids": "b505965x0",
						   "cid":  "1797EB0A-B5D4-11E3-91A6-382D293232C8"
						 };
						 
		subscribers = [ subscription_1, subscription_2 ];
	}
	
	// Listen for "foursquare checkin" event
 	rule process_fs_checkin is active {
 		select when foursquare checkin
 		// store venue name, city, shout, and createdAt event attributes in entity variables
 		pre {
			// extract values from event
			checkin = event:attr("checkin").decode();
			venue_name = checkin.pick("$..venue.name");
			city = checkin.pick("$..location.city");
			shout = checkin.pick("$..shout", true).head();
			createdAt = checkin.pick("$..createdAt");
			latitude = checkin.pick("$..venue.location.lat");
			longitude = checkin.pick("$..venue.location.lng");
			val_map = { 
						"venue":     venue_name,
						"city" :     city,
						"shout" :    shout,
						"createdAt": createdAt,
						"lat":       latitude,
						"lng":       longitude
					  };
 		}
 		
 		send_directive(venue_name) with body = { "key": "checkin",
												 "value": venue_name };
 		
		fired {
			//mark ent:checkin with checkin.encode();
			mark ent:venue_name with venue_name;
			mark ent:city with city;
			mark ent:shout with shout;
			mark ent:created with createdAt;
			
			mark ent:val_map with val_map;
			
			// raise a pds:new_location_data
			// key: fs_checkin
			// value: map with checkin info 
			raise pds event "new_location_data"
				with key = "fs_checkin"
				 and value = val_map;
		}
 	}
 	
 	
	// A dispatch rule that uses foreach to loop over the subscription map
	// and the event:send() action to send a location:notification event
	// to each subscriber
	rule dispatch_location_notification is active {
		select when foursquare checkin
			foreach subscribers setting (subscriber)
			pre {
				name = subscriber{"rids"};
				cid = subscriber{"cid"};
				location = current ent:val_map;
			}
			{
				send_directive(name) with body = { "key": name,
												 "value": cid };
				event:send(subscriber, "location", "notification")
					with attrs = { "location": location};
			}
	}
 	
 	
 	// Shows checkin results in SquareTag
 	rule display_checkin {
 		select when web cloudAppSelected
 		pre {
			//checkin = current ent:checkin;
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
				<div id="checkin"></div>
			>>;
 		}
 		{
 			SquareTag:inject_styling();
 			CloudRain:createLoadPanel("Foursquare Checkin", {}, html);
 			//replace_inner("#event", checkin);
 			replace_inner("#venue_name", venue_name);
 			replace_inner("#city", city);
 			replace_inner("#shout", shout);
 			replace_inner("#created", created);
 		}
 	}
}
