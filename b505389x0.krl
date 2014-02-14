ruleset b505389x0 {
	meta {
		name "notify example"
		description <<
			Notify Example
		>>
		author "Jessica"
		logging off
	}
	dispatch {
		domain "ktest.heroku.com"
	}
	
	// 1/2. create a rule that fires a notification
	// modify the rule to place two notification
	// boxes on the page from the same rule.
	rule two_notifications {
		select when pageview ".*"
		{
			// Display notification that will not fade.
			notify("Notification 1", "This is a notification.") with sticky = true;
			notify("Notification 2", "This is another notification from the same rule") with sticky = true;
		}
	}
	
	// 3. Add a second rule that places a third notification box on the page.
	//	  This notification box should say "Hello [...]" followed bu the value
	//	  of the query string (if empty, default to "Monkey").
	rule hello_notification {
		select when pageview ".*"
		
		pre {
			// pre-condition: query has "name=" in it
			extract_name = function() {
				// get query from url
				// parse query by '&'
				// see if any of the elements are name=x
				// if yes, set name to x
				// if not, set name to Monkey
				
				// see if name=[...] is in query
				// notify value of name if it exists
				// otherwise, notify "Monkey"			
				//query = page:url("query");
				query = page:url("query").match(re/name=/) => query.match(re/name=.*&/) => page:url("query").extract(re/name=(.*)&/).head() 
																							| page:url("query").extract(re/name=(.*)/).head() 
																| "Monkey";
				
				query;
			}
		}
		{
			
			notify("Hello", "Hello, " + extract_name()) with sticky = true;
		}
	}
	
	
	
	// 5. [Rule] Count the number of times it has fired and stop showing its notification
	//	  after five time for any given user. Display the count in the notification.
	rule count_visits {
		select when pageview ".*"
		pre {
			visits = ent:page_visits;
		}
		if ent:page_visits <= 5 then
			notify("Visits", "Visited " + visits + " times.") with sticky = true;
		fired {
			ent:page_visits += 1 from 1;
		}
	}
	
	// 6. [Rule] Clear the count from 5 if a query string parameter named clear is given
	//	  in exampley.com URL
	rule clear_visits {
		select when pageview ".*"
		
		if page:url("query").match(re/clear=/) then {
			notify("Clear", "Clear count");
		}
		fired {
			clear ent:page_visits;
		}
	}
}
