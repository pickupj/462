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
	
	// Listens for the explicit location_nearby event 
	rule nearby is active {
 		select when explicit location_nearby
 		pre {
			distance = event:attr("distance");
 		}
 		{
			send_directive("distance") with body = distance;
			twilio:send_sms("8017030552","3852357271","You are " + distance + " away from your last checkin");
		}
	}
}
