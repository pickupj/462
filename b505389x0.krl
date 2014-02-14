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
	
	// 1/2. Create a rule that fires a notification
	// 		Modify the rule to place two notification
	// 		boxes on the page from the same rule.
	rule two_notifications {
		select when pageview ".*"
		{
			notify("Notification 1", "This is a notification.") with sticky = true;
			notify("Notification 2", "This is another notification from the same rule") with sticky = true;
		}
	}
	
	// 3. Add a second rule that places a third notification box on the page.
	//	  This notification box should say "Hello [...]" followed by the value
	//	  of the query string (if empty, default to "Monkey").
	rule hello_notification {
		select when pageview ".*"
		
		pre {
			// 4. Write a function that give a string in standard URL
			//	  encoding returns the value of the key name. Use this
			//	  function with the query string to modify the rule
			//    from (3). Still default to "Monkey"
			extract_name = function(url) {
				query = url.match(re/name=/) => url | "Monkey";
				
				value = query.match(re/name=.*/) => page:url("query").extract(re/name=(.*)/).head() 
												   | "Monkey";
				name = value.match(re/&/) => value.split(re/&/).head() | value;
				name;
			}
		}
		{
			
			notify("Hello", "Hello, " + extract_name(page:url("query"))) with sticky = true;
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
