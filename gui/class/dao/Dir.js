qx.Mixin.define("dao.Dir",
{
	properties:
	{
		name: { check: "String", init: "" },
		path: { check: "String", init: ""}
	},
	
	members:
	{
		delete_: function(){
			if (this.getTree().is_read_only()) {
				main.Obj.statusbar.fail("Delete: readonly dir");
				return;
			}
			
			var rq = new lang.WRequest(
				"wc", "delete",
				{
					wc_id: 0,
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
