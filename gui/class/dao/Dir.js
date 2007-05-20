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
			var rq = new main.WRequest(
				"wc", "delete",
				{
					session_id: main.Obj.session.getID(),
					path: this.getPath()
				},
				function(data){
					main.Obj.statusbar.ok("Deleted: "+data);
				},
				this
			);
			main.Obj.statusbar.process("Deleting: "+this.getPath());
			rq.send();
		}
	}
});
