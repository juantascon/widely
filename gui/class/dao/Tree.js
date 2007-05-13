qx.Mixin.define("dao.Tree",
{
	properties:
	{
		version: { check: "Number", init: main.Cons.WC }
	},
	
	members:
	{
		is_read_only: function() {
			return (this.getVersion() != main.Cons.WC);
		},
		
		load: function(){
			var rq = new lang.WRequest(
				"wc", "ls",
				{ wc_id: 0, path: "/", version: this.getVersion() },
				function(data){
					this.load_from_hash(data, false);
					main.Obj.statusbar.ok("Loaded: Tree");
				},
				this
			);
			main.Obj.statusbar.process("Loading: Tree");
			rq.send();
		},
		
		commit: function(){
			var rq = new lang.WRequest(
				"wc", "commit",
				{ wc_id: 0, log: "version_automatica" },
				function(data){
					main.Obj.statusbar.ok("Commit: "+data);
					main.Obj.selector.getVmtable().load();
				},
				this
			);
			main.Obj.statusbar.process("Commiting");
			rq.send();
		},
		
		add_: function(_path){
			var rq = new lang.WRequest(
				"wc", "add",
				{ wc_id: 0, path: _path },
				function(data){
					main.Obj.statusbar.ok("Added: "+data);
				},
				this
			);
			main.Obj.statusbar.process("Adding: "+_path);
			rq.send();
		}
	}
});
