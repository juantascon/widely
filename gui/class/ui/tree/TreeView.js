qx.Class.define("ui.tree.TreeView",
{
	type: "singleton",
	
	extend: qx.ui.layout.VerticalBoxLayout,
	
	construct: function () {
		qx.ui.layout.VerticalBoxLayout.call(this);
		this.set({height: "100%", width: "100%"});
		
		this.setTree(new qx.ui.tree.Tree("/"));
		with(this.getTree()) {
			set({height: "100%", width: "100%"});
			setBackgroundColor(255);
			setOverflow("auto");
			setBorder(new qx.renderer.border.Border(1, "solid", "#91A5BD"));
		}
		
		this.load_tree();
		this.add(this.getTree());
	},
	
	properties:
	{
		tree: { check: "qx.ui.tree.Tree" }
	},
	
	members:
	{
		load_tree: function(){
			var rq = new lang.WRequest(
				"wc", "ls",
				{ wc_id: 0, path: "/" },
				function(data){
					for (var i in data){
						if (data[i]["type"] == "dir"){
							this.getTree().addToFolder(ui.tree.Dir.new_from_hash(data[i]));
						}
						if (data[i]["type"] == "file"){
							this.getTree().addToFolder(ui.tree.File.new_from_hash(data[i]));
						}
					}
				},
				this
			);
			
			rq.send();
		}
	}
});
