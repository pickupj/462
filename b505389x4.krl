ruleset location_data {
	meta {
		name "Data Storage"
		description <<
			Lab 6: Data Storage Module
		>>
		author "Jessica"
		logging off

 		provides get_location_data
	}
	
	global {
		// return the value of the key in the map entity variable
		get_location_data = function(key) {
			value = ent:mymap{key};
			value;
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
