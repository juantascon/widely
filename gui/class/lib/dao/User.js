qx.Mixin.define("lib.dao.User",
{
	members:
	{
		user_create: function(user_id, password) {
			return ( new lib.dao.WRQ("user", "create",
				{ "session_id": global.session.id, "user_id": user, "password": password },
				"Creating User") );
		},
		
		user_list: function(wc_id){
			return ( new lib.dao.WRQ("user", "list",
				{ "session_id": global.session.id },
				"Loading User List") );
		}
	}
});
