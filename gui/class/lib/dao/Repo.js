qx.Mixin.define("lib.dao.Repo",
{
	members:
	{
		dao_manager_list: function() {
			return ( new lib.dao.WRQ("repo", "manager_list",
				{ "session_id": global.session.id },
				"Get Manager List") );
		},
		
		dao_create: function(name, manager) {
			return ( new lib.dao.WRQ("repo", "create",
				{ "session_id": global.session.id, "name": name, "manager": manager },
				"Login") );
		},
		
		dao_list: function() {
			return ( new lib.dao.WRQ("repo", "list",
				{ "session_id": global.session.id },
				"Get Repos List") );
		}
	}
});
