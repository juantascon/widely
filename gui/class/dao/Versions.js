qx.Mixin.define("dao.Versions",
{
	members:
	{
		dao_load: function(){
			var rq = new core.WRequest(
				"wc", "versions",
				{
					session_id: core.Obj.session.getID()
				},
				function(data){
					this.load_from_hash(data);
					core.Obj.statusbar.ok("Loaded: Versions");
				},
				this
			);
			
			core.Obj.statusbar.process("Loading: Versions");
			rq.send();
		}
	}
});
