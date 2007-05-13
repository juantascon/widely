qx.Mixin.define("dao.Versions",
{
	members:
	{
		dao_load: function(){
			var rq = new lang.WRequest(
				"wc", "versions",
				{ wc_id: 0 },
				function(data){
					this.load_from_hash(data);
					main.Obj.statusbar.process("Loaded: Versions");
				},
				this
			);
			
			main.Obj.statusbar.process("Loading: Versions");
			rq.send();
		}
	}
});
