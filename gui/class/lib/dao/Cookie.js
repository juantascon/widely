qx.Class.define("lib.dao.Cookie",
{
	type: "static",
	
	statics:
	{
		set_session_id: function(app, session_id) {
			qx.io.local.CookieApi.set(app+".session_id", session_id);
		},
		
		get_session_id: function() {
			return qx.io.local.CookieApi.get(global.app.name+".session_id");
		}
	}
});
