qx.Class.define("tree.TreeView",
{
	type: "singleton",
	extend: qx.ui.layout.VerticalBoxLayout,
	construct: function () {
		qx.ui.layout.VerticalBoxLayout.call(this);
		with(this) {
			setEdge(0);
			set({left: 0, right: 0, top: 0, bottom: 0});
			set({heights: "100%", widths: "100%"});
		}
		
		this.setTree(new qx.ui.tree.Tree("/"));
		with(this.getTree()) {
			setEdge(0);
			set({left: 0, right: 0, top: 0, bottom: 0});
			set({heights: "100%", widths: "100%"});
			
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
			var rq = new qx.io.remote.Request("/api/wc/ls", "POST", qx.util.Mime.JSON);
			rq.setData(lang.Encode.encodeObj({wc_id: 0, path: "/"}));
			
			rq.addEventListener("completed", function(e){
				resp = e.getData();
				if (resp.getStatusCode() == 200){ // Status: OK
					data = resp.getContent();
					for (var i in data){
						if (data[i]["type"] == "dir"){
							this.getTree().addToFolder(tree.Dir.new_from_hash(data[i]));
						}
						if (data[i]["type"] == "file"){
							this.getTree().addToFolder(tree.File.new_from_hash(data[i]));
						}
					}
				}
			}, this);
			
			rq.send();
		}
	}
});
