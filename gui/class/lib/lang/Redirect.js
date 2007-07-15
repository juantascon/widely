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
			lib.lang.Redirect.redirect_to(global.fallback_url);
		}
	}
});
