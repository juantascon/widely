qx.Mixin.define("lib.dao.WC",
{
	members:
	{
		dao_manager_list: function() {
			return ( new lib.dao.WRQ("repo", "manager_list",
				{ "session_id": widely.session_id },
				"Get Manager List") );
		},
		
		dao_create: function(repo_id, name, manager) {
			return ( new lib.dao.WRQ("wc", "create",
				{ "session_id": widely.session_id, "repo_id": repo_id, "name": name, "manager": manager },
				"Create WC") );
		},
		
		dao_list: function(_user, _password) {
			return ( new lib.dao.WRQ("wc", "list",
				{ "session_id": widely.session_id },
				"Get WCs List") );
		},
		
		dao_checkout: function(version=null) {
			if (! version) { version = "-1" }
			
			return ( new lib.dao.WRQ("wc", "checkout",
				{ "session_id": widely.session_id, "version": version },
				"Checkout") );
		},
		
		dao_commit: function(log) {
			return ( new lib.dao.WRQ("wc", "commit",
				{ "session_id": widely.session_id, "log": log },
				"Commit") );
		},
		
		dao_version_list: function() {
			return ( new lib.dao.WRQ("wc", "version_list",
				{ "session_id": widely.session_id },
				"Get Version List") );
		},
		
		dao_cat: function(path, version=null) {
			if (! version) { version = "-1" }
			
			return ( new lib.dao.WRQ("wc", "cat",
				{ "session_id": widely.session_id, "path": path, "version": version },
				"Load File Content") );
		},
		
		dao_ls: function(path, version=null) {
			if (! version) { version = "-1" }
			
			return ( new lib.dao.WRQ("wc", "ls",
				{ "session_id": widely.session_id, "path": path, "version": version },
				"Load Dir Listing") );
		},
		
		dao_add: function(path, as_dir=false) {
			return ( new lib.dao.WRQ("wc", "add",
				{ "session_id": widely.session_id, "path": path, "as_dir": as_dir },
				"Load Dir Listing") );
		},
		
		dao_delete: function(path) {
			return ( new lib.dao.WRQ("wc", "delete",
				{ "session_id": widely.session_id, "path": path },
				"Load Dir Listing") );
		},
		
		dao_move: function(path_from, path_to) {
			return ( new lib.dao.WRQ("wc", "move",
				{ "session_id": widely.session_id, "path_from": path_from, "path_to": path_to },
				"Move") );
		},
		
		dao_write: function(path, content) {
			return ( new lib.dao.WRQ("wc", "write",
				{ "session_id": widely.session_id, "path": path, "content": content },
				"Write File Content") );
		}
	}
});
