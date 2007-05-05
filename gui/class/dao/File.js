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
				{ wc_id: 0, path: this.getPath() },
				function(data){
					ui.StatusBar.getInstance().ok("Loaded");
					this.getTextarea().setValue(""+data);
				},
				this
			);
			ui.StatusBar.getInstance().process("Loading: "+this.getPath());
			rq.send();
		},
		
		save: function(){
			var rq = new lang.WRequest(
				"wc", "write",
				{
					wc_id: 0,
					path: this.getPath(),
					content: this.getTextarea().getComputedValue()
				},
				function(data){
					ui.StatusBar.getInstance().ok("Saved: "+data+" bytes");
				},
				this
			);
			ui.StatusBar.getInstance().process("Saving");
			rq.send();
		}
	}
});
