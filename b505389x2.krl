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
		
		// use http:get() to interact with movies.json
		// endpoint of the Rotten Tomatoes API
		// Be sure to include your API key as the first
		// argument of the query string
		searchAPI = function(title) {
			query = http:get("http://api.rottentomatoes.com/api/public/v1.0/movies.json",
					 { "apikey": "s75adz3v9ujbxs94hjcmvfv3",
					   "q": title,
					   "page_limit": "1"
					 });
			query.pick("$.content");
		};
	}
	
	// display a form that asks the user for a movie title
 	rule movie_title_form is active {
 		select when web cloudAppSelected
 		pre {
			form = <<
				<div>
				<p id="thumbnail" />
				<h2><p id="title" /></h2>
				<p id="release" />
				<p id="synopsis" />
				<p id="critic_ratings" />
				</div>
				<form id="movie_title_form">
					Title: <input type="text" name="movie_title" />
					<input type="submit" value="Search" />
				</form>
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
			data = searchAPI(title).decode();
			
			movie = data.pick("$.movies");
			
			thumbnail = movie.pick("$..posters.thumbnail");
			title = movie.pick("$..title");
			release_year = movie.pick("$..year");
			synopsis = movie.pick("$..synopsis");
			critic_ratings = movie.pick("$..ratings.critics_rating");
		}
		{
			//replace_inner("#search_results", data);
			replace_inner("#thumbnail", "<img src='" + thumbnail + "' alt='Could not load image'>");
			replace_inner("#title", title);
			replace_inner("#release", release_year);
			replace_inner("#synopsis", synopsis);
			replace_inner("#critic_ratings", "Critics: <i>" + critic_ratings + "</i>");
		}
	}
}
