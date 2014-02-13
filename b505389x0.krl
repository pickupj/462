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
	rule first_rule {
		select when pageview ".*" setting()
		// Display notification that will not fade.
		notify("Notification 1", "This is a notification.") with sticky = true;
		notify("Notification 2", "This is another notification from the same rule") with sticky = true;
	}
}
