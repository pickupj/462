ruleset rotten_tomatoes {
	meta {
		name "Rotten Tomatoes"
		description <<
			Lab 4: Rotten Tomatoes API
		>>
		author "Jessica"
		logging off
		
 		use module a169x701 alias CloudRain
 		use module a41x186  alias SquareTag
	}
	
	global {
		api_key = "s75adz3v9ujbxs94hjcmvfv3";
		base_url = "http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=" + api_key;
		
		// use http:get() to interact with movies.json
		// endpoint of the Rotten Tomatoes API
		// Be sure to include your API key as the first
		// argument of the query string
		searchAPI = function(title) {
			// TODO need to encode title
			data = http:get(base_url + "&q=" + title + "&page_limit=1");
			data;
		}
	}
	
	// display a form that asks the user for a movie title
 	rule movie_title_form is active {
 		select when web cloudAppSelected
 		pre {
			form = << 
				<form id="movie_title_form">
					Title: <input type="text" name="movie_title" />
					<input type="submit" value="Search" />
				</form>
				<p id="search_results" />
			>>;
 		}
 		{
 			SquareTag:inject_styling();
 			CloudRain:createLoadPanel("Rotten Tomamotes", {}, form);
			watch("#movie_title_form", "submit");
 		}
 	}
 	
 	// extract the movie title from the form and
 	// query the Rotten Tomatoes datasource with
 	// the movie title and retrieve the desired
 	// information (e.g., critic and audience ratings)
 	// from the JSON response using the pick() operator
 	// Display the following:
 	//	a. Movie thumbnail
 	//	b. Title
 	//	c. Release Year
 	//	d. Synopsis
 	//	e. Critic ratings
 	//	f. ...any other interesting data
 	rule respond_search is active {
		select when web submit "#movie_title_form"
		
		pre {
			title = page:param("movie_title");
			data = searchAPI(title);
		}
		replace_inner("#search_results", data.pick("$.title"));
	}
}
