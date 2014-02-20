ruleset b505389x1 {
	meta {
		name "Lab 3"
		description <<
			Lab 3: Web Rule Exercises
		>>
		author "Jessica"
		logging off
	}
	
	dispatch {
		domain "ktest.heroku.com"
	}
	
	// 1) Write a rule called show_form that inserts
	//	  text paragraph (make up the text) in the
	//    <div/> element with the ID of main on ktest.heroku.com
	rule show_form {
		select when pageview ".*"
		{
			replace_html("#main", "<p>Hello World</p>");
			notify("Notification 1", "This is a notification.") with sticky = true;
			notify("Notification 2", "This is another notification from the same rule") with sticky = true;
		}
	}
	// 2) Modify the show_form rule from (1) to place
	//    a simple Web form that has field for a first
	//    name, a last name, and a submit button.
	//    Use the watch() action to watch it for activity
	
	// 3) Write a rule that selects on submit and takes
	//    the first and last name from the form in (3) and
	//    stores them in entity variables.
	
	// 4) Modify the ruleset so that if a first and last name
	//    have been stord, they are displayed in the page
	//    (in a paragraph under the form) and if they are not,
	//    the form is displayed.
	
	// 5) Add a clear rule that clears the names if the query
	//    string clear=1 is added to the URL
}
