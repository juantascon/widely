qx.Class.define("ui.tree.Tree",
{
	extend: qx.ui.tree.Tree,
	
	include: dao.Tree,
	
	construct: function () {
		qx.ui.tree.Tree.call(this, "/");
		
		this.set({height: "1*", width: "100%"});
		this.setBackgroundColor(255);
		this.setOverflow("auto");
		this.setBorder(new qx.renderer.border.Border(1, "solid", "#91A5BD"));
		this.load();
	},
	
	members:
	{
		load_from_hash: function(data) {
			this.destroyContent();
			
			for (var i in data){
				if (data[i]["type"] == "dir"){
					this.addToFolder(ui.tree.Dir.new_from_hash(data[i]));
				}
				if (data[i]["type"] == "file"){
					this.addToFolder(ui.tree.File.new_from_hash(data[i]));
				}
			}
		}
	}
});
