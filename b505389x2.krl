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
	
 	rule HelloWorld is active {
 		select when web cloudAppSelected
 		pre {
 			my_html = <<
 				<h5>Hello, world!</h5>
 			>>;
 		}
 		{
 			SquareTag:inject_styling();
 			CloudRain:createLoadPanel("Hello World!", {}, my_html);
 		}
 	}
}
