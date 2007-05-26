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
			var rq = new core.WRequest(
				"wc", "cat",
				{
					session_id: core.Obj.session.getID(),
					path: this.getPath(),
					version: this.getTree().getVersion()
				},
				function(data){
					core.Obj.statusbar.ok("Loaded: "+this.getPath());
					this.getTextarea().setValue(""+data);
				},
				this
			);
			core.Obj.statusbar.process("Loading: "+this.getPath());
			rq.send();
		},
		
		dao_save: function(){
			if (this.getTree().is_read_only()) {
				core.Obj.statusbar.fail("Save: readonly file");
				return;
			}
			
			var rq = new core.WRequest(
				"wc", "write",
				{
					session_id: core.Obj.session.getID(),
					path: this.getPath(),
					content: this.getTextarea().getComputedValue()
				},
				function(data){
					core.Obj.statusbar.ok("Saved: "+this.getPath()+" "+data+" bytes");
				},
				this
			);
			core.Obj.statusbar.process("Saving: "+this.getPath());
			rq.send();
		},
		
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
