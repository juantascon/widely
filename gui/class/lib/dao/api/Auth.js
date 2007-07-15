qx.Mixin.define("lib.dao.api.Auth",
{
	members:
	{
		auth_login: function(user, password) {
			return ( new lib.dao.WRQ("auth", "login",
				{ "user_id": user, "password": password },
				"Login") );
		},
		
		auth_login_admin: function(password) {
			return ( new lib.dao.WRQ("auth", "login_admin",
				{ "password": password },
				"Admin Login") );
		},
		
		auth_session_type: function(session_id){
			return ( new lib.dao.WRQ("auth", "session_type",
				{ "session_id": session_id },
				"Checking User Session") );
		},
		
		auth_user_session: function(user_id){
			return ( new lib.dao.WRQ("auth", "user_session",
				{ "session_id": global.session.id, "user_id": user_id },
				"Opening User Session") );
		},
		
		auth_set_wc: function(wc_id){
			return ( new lib.dao.WRQ("auth", "set_wc",
				{ "session_id": global.session.id, "wc_id": wc_id },
				"Setting WC") );
		},
		
		auth_logout: function(){
			return ( new lib.dao.WRQ("auth", "logout",
				{ "session_id": global.session.id },
				"Logout") );
		}
	}
});
