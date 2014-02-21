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
		noop();
		fired {
			mark ent:name with first + " " + last;
			raise explicit event name_set;
		}
	}
	
	
	// 5) Add a clear rule that clears the names if the query
	//    string clear=1 is added to the URL
	rule clear_name {
		select when pageview ".*"
		pre {
			clear_name_func = function(url) {
			
				// check that first 7 letters hold attribute (and if so, that the url equals the first 7 letters)
				first = url.substr(0,7).match(re/clear=1/) => 
						url.substr(0,7).match(url) => "Clear" | "Don't clear" | "Don't clear";
				// check if attribute occurs between &s
				attr = url.match(re/&clear=1&/) => "Clear" | "Don't clear";
				// check if attribute is last
				last = url.extract(re/&clear=1(.*)/).head().match(re/.*/) => "Don't clear" | "Clear";
			
				clear_name = first.match(re/Clear/) => first | 
								attr.match(re/Clear/) => attr | last;
				clear_name;
			}
		}
		
		if clear_name_func(page:url("query")).match(re/Clear/) then {
			noop();
		}
		fired {
			clear ent:name;
		}
	}
	
	// 4) Modify the ruleset so that if a first and last name
	//    have been stored, they are displayed in the page
	//    (in a paragraph under the form) and if they are not,
	//    the form is displayed.
	rule replace_name is active {
		select when explicit name_set 
					or web pageview ".*"
		pre {
			name = current ent:name;
		}
		// checks that there is some value in name
		if name.match(re/.*/) then
			replace_inner("#name_info", "Hello #{name}");
	}
}
