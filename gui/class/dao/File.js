qx.Mixin.define("dao.File",
{
	properties:
	{
		name: { check: "String", init: "" },
		path: { check: "String", init: ""},
		textarea: { check: "qx.ui.form.TextArea" }
	},
	
	members:
	{
		load: function(){
			var rq = new lang.WRequest(
				"wc", "cat",
				{ wc_id: 0, path: this.getPath(), version: this.getTree().getVersion() },
				function(data){
					main.Obj.statusbar.ok("Loaded: "+this.getPath());
					this.getTextarea().setValue(""+data);
				},
				this
			);
			main.Obj.statusbar.process("Loading: "+this.getPath());
			rq.send();
		},
		
		save: function(){
			if (this.getTree().is_read_only()) {
				main.Obj.statusbar.fail("Save: readonly file");
				return;
			}
			
			var rq = new lang.WRequest(
				"wc", "write",
				{
					wc_id: 0,
					path: this.getPath(),
					content: this.getTextarea().getComputedValue()
				},
				function(data){
					main.Obj.statusbar.ok("Saved: "+this.getPath()+" "+data+" bytes");
				},
				this
			);
			main.Obj.statusbar.process("Saving: "+this.getPath());
			rq.send();
		},
		
		delete_: function(){
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
