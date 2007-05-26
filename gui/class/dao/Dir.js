qx.Mixin.define("dao.Dir",
{
	properties:
	{
		name: { check: "String", init: "" },
		path: { check: "String", init: ""}
	},
	
	members:
	{
		dao_delete: function(){
			var rq = new core.WRequest(
				"wc", "delete",
				{
					session_id: core.Obj.session.getID(),
					path: this.getPath()
				},
				function(data){
					core.Obj.statusbar.ok("Deleted: "+data);
				},
				this
			);
			core.Obj.statusbar.process("Deleting: "+this.getPath());
			rq.send();
		}
	}
});
