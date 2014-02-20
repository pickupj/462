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
		pre {
			// 2) Modify the show_form rule from (1) to place
			//    a simple Web form that has fields for a first
			//    name, a last name, and a submit button.
			//    Use the watch() action to watch it for activity
			
			form = << <form id="name_form">
						First name: <input type="text" name="first_name" />
						Second name: <input type="text" name="last_name" />
						<input type="submit" value="Submit" />
					  </form>
					  <p id="name_info">
			>>;
		}
		{
			replace_inner("#main", form);
			watch("#name_form", "submit");
		}
	}
	
	// 3) Write a rule that selects on submit and takes
	//    the first and last name from the form in (3) and
	//    stores them in entity variables.
	rule respond_submit is active {
		select when web submit "#name_form"
		
		pre {
			first = page:param("first_name");
			last = page:param("last_name");
		}
		notify("Submit", "Form was submitted: " + first + " " + last);
		fired {
			mark ent:name with first + " " + last;
			raise explicit event name_set;
		}
	}
	
	// 4) Modify the ruleset so that if a first and last name
	//    have been stored, they are displayed in the page
	//    (in a paragraph under the form) and if they are not,
	//    the form is displayed.
	rule replace_name is active {
		select when explicit name_set or web pageview ".*"
		pre {
			name = current ent:name;
		}
		replace_inner("#name_info", "Hello #{name}");
	}
	
	
	// 5) Add a clear rule that clears the names if the query
	//    string clear=1 is added to the URL
}
