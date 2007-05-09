qx.Mixin.define("dao.Tree",
{
	properties:
	{
		version: { check: "Number", init: -1 }
	},
	
	members:
	{
		load: function(){
			var rq = new lang.WRequest(
				"wc", "ls",
				{ wc_id: 0, path: "/", version: this.getVersion() },
				function(data){
					this.load_from_hash(data);
					ui.StatusBar.getInstance().ok("Loaded: Tree");
				},
				this
			);
			ui.StatusBar.getInstance().process("Loading: Tree");
			rq.send();
		},
		
		commit: function(){
			var rq = new lang.WRequest(
				"wc", "commit",
				{ wc_id: 0, log: "version_automatica" },
				function(data){
					ui.StatusBar.getInstance().ok("Commit: "+data);
				},
				this
			);
			ui.StatusBar.getInstance().process("Commiting");
			rq.send();
		}
	}
});
