ruleset nearby {
	meta {
		name "Analyze Location"
		description <<
			Lab 7: Event Network Exercise (Semantic Translation)
		>>
		author "Jessica"
		logging off
		
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
 		noop();
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
