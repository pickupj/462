ruleset location_notification {
	meta {
		name "Location Notification"
		description <<
			Lab 8: Dispatching Events Exercise
		>>
		author "Jessica"
		logging off
		
		use module a169x701 alias CloudRain
 		use module a41x186  alias SquareTag
	}
	
	// Listens for the location notification event
	rule location_catch is active {
 		select when location notification
 		pre {
 		
 		}
		send_directive("location_catch") with body = "rule fired";
 		fired {
			mark ent:location with "rule fired"
		}
	}
	
	rule location_show is active {
	 	select when web cloudAppSelected
 		pre {
			html = <<
				<div id="location></div>
			>>;
 		}
 		{
 			SquareTag:inject_styling();
 			CloudRain:createLoadPanel("Location", {}, html);
 		}
	}
}
