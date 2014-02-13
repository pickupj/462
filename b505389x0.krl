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
		notify("Hello World", "This is a sample rule.") with sticky = true;
	}
}
