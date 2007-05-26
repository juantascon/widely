qx.Mixin.define("dao.Tree",
{
	properties:
	{
		version: { check: "Number", init: core.Cons.WC }
	},
	
	members:
	{
		is_read_only: function() {
			return (this.getVersion() != core.Cons.WC);
		},
		
		dao_load: function(){
			var rq = new core.WRequest(
				"wc", "ls",
				{
					session_id: core.Obj.session.getID(),
					path: "/",
					version: this.getVersion()
				},
				function(data){
					this.load_from_hash(data, false);
					core.Obj.statusbar.ok("Loaded: Tree");
				},
				this
			);
			core.Obj.statusbar.process("Loading: Tree");
			rq.send();
		},
		
		dao_commit: function(_log){
			var rq = new core.WRequest(
				"wc", "commit",
				{
					session_id: core.Obj.session.getID(),
					log: _log
				},
				function(data){
					core.Obj.statusbar.ok("Commit: "+data);
					core.Obj.selector.getVmtable().dao_load();
				},
				this
			);
			core.Obj.statusbar.process("Commiting");
			rq.send();
		},
		
		dao_add: function(_path){
			var rq = new core.WRequest(
				"wc", "add",
				{
					session_id: core.Obj.session.getID(),
					path: _path
				},
				function(data){
					core.Obj.statusbar.ok("Added: "+data);
				},
				this
			);
			core.Obj.statusbar.process("Adding: "+_path);
			rq.send();
		}
	}
});
