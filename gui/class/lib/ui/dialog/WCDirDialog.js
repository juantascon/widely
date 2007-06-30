qx.Class.define("lib.ui.dialog.WCDirDialog",
{
	extend: lib.ui.dialog.Dialog,
	
	include: lib.dao.WC,
	
	properties:
	{
		tree: { check: "qx.ui.tree.Tree" }
	},
	
	construct: function (title, message) {
		this.setTree(new qx.ui.tree.Tree("/"));
		this.getTree().setSelectedElement(this.getTree());
		
		with(this.getTree()) {
			set({height: 300, width: 200});
			setBackgroundColor("white");
			setOverflow("scroll");
		}
		
		this.load_tree();
		this.base(arguments, title, message, this.getTree());
	},
	
	members:
	{
		new_dir_from_hash: function(data) {
			var dir = new qx.ui.tree.TreeFolder(data["text"]);
			
			if ( data["childs"] ) {
				for (var i in data["childs"]) {
					if (data["childs"][i]["type"] == "dir"){
						dir.addToFolder(this.new_dir_from_hash(data["childs"][i]));
					}
				}
			}
			
			return dir;
		},
		
		load_tree: function(){
			var load_rq = this.dao_ls("/", cons.WC);
			load_rq.addEventListener("ok", function(e) {
				var data = e.getData();
				for (var i in data){
					if (data[i]["type"] == "dir"){
						this.getTree().addToFolder(this.new_dir_from_hash(data[i]));
					}
				}
			}, this);
		},
		
		selected_path: function() {
			var selected = this.getTree().getSelectedElement();
			if ( qx.util.Validation.isInvalid([selected]) ) { return "/"; }
			
			var h = selected.getHierarchy([]);
			h[0] = "";
			
			var path = "";
			for(var i in h) {
				path = path+h[i]+"/";
			}
			return path;
		}
	}
});
