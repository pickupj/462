ruleset twilio {
	meta {
		name "Twilio"
		description <<
			Lab 7: Event Network Exercise (Semantic Translation) - Twilio notification
		>>
		author "Jessica"
		logging off
		
		// twilio phone number: (385) 235-7271
		key twilio { "account_sid": "AC0059220c90e4ba5eb876cff8b7bbf6cb", //ACc046efdd610af3c0cce3549c59c6dfbe
					 "auth_token": "1f5194b817106e46e5796ba477a52f84"     //4a4edc01d88d7a2a29515d8b73296743
				   }

		use module a8x115 alias twilio with twiliokeys = keys:twilio()
		
		use module a169x701 alias CloudRain
 		use module a41x186  alias SquareTag
	}
	
	global {
	}
	
	// Listens for the new_current:location event 
	rule nearby is active {
 		select when explicit location_nearby
 		pre {
			distance = event:attr("distance");
 		}
		twilio:send_sms("18017030552","3852357271",distance);
 		fired {
			mark ent:distance with distance;
		}
	}
	rule show_nearby is active {
 		select when web cloudAppSelected
 		pre {
			info = current ent:distance;
 		
			html = <<
				<h3>Nearby</h3>
				<div>Distance: <div id="distance"></div></div>
			>>;
 		}
 		{
 			SquareTag:inject_styling();
 			CloudRain:createLoadPanel("Distance", {}, html);
 			replace_inner("#distance", info);
 		}
	}
}
