qx.Class.define("lib.lang.Redirect",
{
	type: "static",
	
	statics:
	{
		redirect_to: function(url) {
			if (qx.util.Validation.isInvalidString(url)) { return false; }
			
			window.location = url;
		},
		
		fallback_redirect: function() {
			var fallback_url = "./login.html";
			lib.lang.Redirect.redirect_to(fallback_url);
		}
	}
});
