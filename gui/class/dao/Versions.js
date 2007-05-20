qx.Mixin.define("dao.Versions",
{
	members:
	{
		dao_load: function(){
			var rq = new main.WRequest(
				"wc", "versions",
				{
					session_id: main.Obj.session.getID()
				},
				function(data){
					this.load_from_hash(data);
					main.Obj.statusbar.ok("Loaded: Versions");
				},
				this
			);
			
			main.Obj.statusbar.process("Loading: Versions");
			rq.send();
		}
	}
});
