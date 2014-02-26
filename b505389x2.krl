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
	
 	rule movie_title_form is active {
 		select when web cloudAppSelected
 		pre {
			form = << 
				<form id="movie_title_form">
					Title: <input type="text" name="movie_title" />
				</form>
			>>;
 		}
 		{
 			SquareTag:inject_styling();
 			CloudRain:createLoadPanel("Rotten Tomamotes", {}, form);
 		}
 	}
}
