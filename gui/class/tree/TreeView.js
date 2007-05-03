qx.Class.define("tree.TreeView",
{
	type: "singleton",
	extend: qx.ui.layout.BoxLayout,
	construct: function () {
		qx.ui.layout.BoxLayout.call(this, "vertical");
		this.set({left: 0, right: 0, top: 0, bottom: 0});
		
		this.setTree(new qx.ui.tree.Tree("/"));
		with(this.getTree()) {
			setBackgroundColor(255);
			setOverflow("auto");
			setBorder(new qx.renderer.border.Border(1, "solid", "#91A5BD"));
			setHeight("100%");
			setWidth("100%");
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
			var _this = this;
			var rq = new qx.io.remote.Request("/api/wc/ls", "POST", qx.util.Mime.JSON);
			rq.setData(lang.Encode.encodeObj({wc_id: 0, path: "/"}));
			
			rq.addEventListener("completed", function(e){
				resp = e.getData();
				if (resp.getStatusCode() == 200){ // Status: OK
					data = resp.getContent();
					for (var i in data){
						if (data[i]["type"] == "dir"){
							_this.getTree().addToFolder(tree.Dir.new_from_hash(data[i]));
						}
						if (data[i]["type"] == "file"){
							_this.getTree().addToFolder(tree.File.new_from_hash(data[i]));
						}
					}
				}
			});
			
			rq.send();
		}
	}
});
