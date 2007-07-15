qx.Mixin.define("lib.dao.api.WC",
{
	members:
	{
		wc_manager_list: function() {
			return ( new lib.dao.WRQ("wc", "manager_list",
				{ "session_id": global.session.id },
				"Get Manager List") );
		},
		
		wc_create: function(repo_id, name, manager) {
			return ( new lib.dao.WRQ("wc", "create",
				{ "session_id": global.session.id, "repo_id": repo_id, "name": name, "manager": manager },
				"Create WC") );
		},
		
		wc_list: function(_user, _password) {
			return ( new lib.dao.WRQ("wc", "list",
				{ "session_id": global.session.id },
				"Get WCs List") );
		},
		
		
		wc_checkout: function(version) {
			if (! version) { version = "-1" }
			
			return ( new lib.dao.WRQ("wc", "checkout",
				{ "session_id": global.session.id, "version": version },
				"Checkout") );
		},
		
		wc_commit: function(log) {
			return ( new lib.dao.WRQ("wc", "commit",
				{ "session_id": global.session.id, "log": log },
				"Commit") );
		},
		
		wc_version_list: function() {
			return ( new lib.dao.WRQ("wc", "version_list",
				{ "session_id": global.session.id },
				"Get Version List") );
		},
		
		wc_cat: function(path, version) {
			if (! version) { version = "-1" }
			
			return ( new lib.dao.WRQ("wc", "cat",
				{ "session_id": global.session.id, "path": path, "version": version },
				"Load File Content") );
		},
		
		wc_ls: function(path, version) {
			if (! version) { version = "-1" }
			
			return ( new lib.dao.WRQ("wc", "ls",
				{ "session_id": global.session.id, "path": path, "version": version },
				"Load Dir Listing") );
		},
		
		wc_add: function(path, as_dir) {
			if (! as_dir) { as_dir = false }
			return ( new lib.dao.WRQ("wc", "add",
				{ "session_id": global.session.id, "path": path, "as_dir": as_dir },
				"Load Dir Listing") );
		},
		
		wc_delete: function(path) {
			return ( new lib.dao.WRQ("wc", "delete",
				{ "session_id": global.session.id, "path": path },
				"Load Dir Listing") );
		},
		
		wc_move: function(path_from, path_to) {
			return ( new lib.dao.WRQ("wc", "move",
				{ "session_id": global.session.id, "path_from": path_from, "path_to": path_to },
				"Move") );
		},
		
		wc_write: function(path, content) {
			return ( new lib.dao.WRQ("wc", "write",
				{ "session_id": global.session.id, "path": path, "content": content },
				"Write File Content") );
		}
	}
});
