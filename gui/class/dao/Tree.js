qx.Mixin.define("dao.Tree",
{
	members:
	{
		load: function(){
			var rq = new lang.WRequest(
				"wc", "ls",
				{ wc_id: 0, path: "/" },
				function(data){
					this.load_from_hash(data);
					ui.StatusBar.getInstance().process("Loaded: Tree");
				},
				this
			);
			ui.StatusBar.getInstance().process("Loading: Tree");
			rq.send();
		}
	}
});
