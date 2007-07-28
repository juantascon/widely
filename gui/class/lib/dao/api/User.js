qx.Mixin.define("lib.dao.api.User",
{
	members:
	{
		user_create: function(user_id, password) {
			return ( new lib.dao.WRQ("user", "create",
				{ "session_id": global.session.id, "user_id": user_id, "password": password },
				"Create User") );
		},
		
		user_destroy: function(user_id) {
			return ( new lib.dao.WRQ("user", "destroy",
				{ "session_id": global.session.id, "user_id": user_id },
				"Destroy User") );
		},
		
		user_list: function(wc_id){
			return ( new lib.dao.WRQ("user", "list",
				{ "session_id": global.session.id },
				"Load User List") );
		}
	}
});
