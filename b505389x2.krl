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
			html = <<
				<div id="results" hidden>
				<div id="thumbnail" />
				<h2><div id="title" /></h2>
				<br><div id="release" /> - <div id="rating" />
				<i><p id="critics_consensus" /></i>
				<p id="synopsis" />
				<br>Critics: <i><div id="critic_score" /> <div id="critic_rating" /></i>
				<br>Audience: <i><div id="audience_score" /> <div id="audience_rating" /></i>
				</div>
				<br>
				<form id="movie_title_form">
					Title: <input type="text" name="movie_title" />
					<input type="submit" value="Search" />
				</form>
			>>;
 		}
 		{
 			SquareTag:inject_styling();
 			CloudRain:createLoadPanel("Rotten Tomamotes", {}, html);
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
			
			count = data.pick("$.total");
			
			thumbnail = count > 0 => "<img src='" + movie.pick("$..posters.thumbnail") + "' alt='Could not load image'>" | "";
			title = count > 0 => movie.pick("$..title") | "";
			release = count > 0 => movie.pick("$..year") | "";
			rating = count > 0 => movie.pick("$..mpaa_rating") | "";
			synopsis = count > 0 => movie.pick("$..synopsis") | "No results";
			critics_consensus = count > 0 => movie.pick("$..critics_consensus") | "";
			critic_score = count > 0 => movie.pick("$..ratings.critics_score") | "";
			critic_rating = count > 0 => movie.pick("$..ratings.critics_rating") + "</i>" | "";
			audience_score = count > 0 => movie.pick("$..ratings.audience_score") | "";
			audience_rating = count > 0 => movie.pick("$..ratings.audience_rating") + "</i>" | "";
		}
		{
			set_element_attr("#results", "hidden", "false");
			replace_inner("#thumbnail", thumbnail);
			replace_inner("#title", title);
			replace_inner("#release", release);
			replace_inner("#rating", rating);
			replace_inner("#synopsis", synopsis);
			replace_inner("#critics_consensus", critics_consensus);
			replace_inner("#critic_score", critic_score);
			replace_inner("#critic_rating", critic_rating);
			replace_inner("#audience_score", audience_score);
			replace_inner("#audience_rating", audience_rating);
		}
	}
}
