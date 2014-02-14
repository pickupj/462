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
			query = page:url("query").match("*=*") => page:url("query") | "Monkey";	
			
			name = query.match("*name=*") => query.match("*name=(*)") | "Monkey";
		}
		{			
			notify("Hello", "Hello, " + query) with sticky = true;
			notify("Name", name);
		}
	}
	
	
	// 5. [Rule] Count the number of times it has fired and stop showing its notification
	//	  after five time for any given user. Display the count in the notification.
	
	
	// 6. [Rule] Clear the count from 5 if a query string parameter named clear is given
	//	  in exampley.com URL
}
