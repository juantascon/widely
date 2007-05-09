qx.Mixin.define("dao.Versions",
{
	members:
	{
		load: function(){
			var rq = new lang.WRequest(
				"wc", "versions",
				{ wc_id: 0 },
				function(data){
					this.load_from_hash(data);
					ui.StatusBar.getInstance().process("Loaded: Versions");
				},
				this
			);
			
			ui.StatusBar.getInstance().process("Loading: Versions");
			rq.send();
		}
	}
});
