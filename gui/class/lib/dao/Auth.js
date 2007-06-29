qx.Mixin.define("lib.dao.Auth",
{
	members:
	{
		dao_login: function(user, password) {
			return ( new lib.dao.WRQ("auth", "login",
				{ "user_id": user, "password": password },
				"Login") );
		},
		
		dao_set_wc: function(wc_id){
			return ( new lib.dao.WRQ("auth", "set_wc",
				{ "session_id": global.session.id, "wc_id": wc_id },
				"Setting WC") );
		}
	}
});
