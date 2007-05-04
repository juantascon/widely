qx.Class.define("tree.File",
{
	extend: qx.ui.tree.TreeFile,
	
	construct: function (name, path) {
		qx.ui.tree.TreeFile.call(this, name);
		this.setName(name);
		this.setPath(path);
		
		this.addEventListener("click", function(e){
			editor.EditorView.getInstance().getTabview().add_tab(this);
		}, this);
	},
	
	properties:
	{
		name: { check: "String", init: "" },
		path: { check: "String", init: ""},
		textarea: { check: "qx.ui.form.TextArea" }
	},
	
	members:
	{
		load: function(){
			var rq = new widely.RQ(
				"wc", "cat",
				{ wc_id: 0, path: this.getPath() },
				function(data){
					this.getTextarea().setValue(""+data);
				},
				this
			);
			rq.send();
		},
		
		save: function(){
			var rq = new widely.RQ(
				"wc", "write",
				{
					wc_id: 0,
					path: this.getPath(),
					content: this.getTextarea().getComputedValue()
				},
				function(data){
					this.debug("save: "+data);
				},
				this
			);
			rq.send();
		}
	},
	
	statics:
	{
		new_from_hash: function(h){
			return new tree.File(h["text"], h["id"]);
		}
	}
});
