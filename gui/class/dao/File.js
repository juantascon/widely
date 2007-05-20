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
		dao_load: function(){
			var rq = new main.WRequest(
				"wc", "cat",
				{
					session_id: main.Obj.session.getID(),
					path: this.getPath(),
					version: this.getTree().getVersion()
				},
				function(data){
					main.Obj.statusbar.ok("Loaded: "+this.getPath());
					this.getTextarea().setValue(""+data);
				},
				this
			);
			main.Obj.statusbar.process("Loading: "+this.getPath());
			rq.send();
		},
		
		dao_save: function(){
			if (this.getTree().is_read_only()) {
				main.Obj.statusbar.fail("Save: readonly file");
				return;
			}
			
			var rq = new main.WRequest(
				"wc", "write",
				{
					session_id: main.Obj.session.getID(),
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
