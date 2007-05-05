qx.Class.define("ui.tree.Tree",
{
	extend: qx.ui.tree.Tree,
	
	include: dao.Tree,
	
	construct: function (name) {
		this.base(arguments, name);
		
		this.set({height: "1*", width: "100%"});
		this.setBackgroundColor(255);
		this.setOverflow("auto");
		this.setBorder(new qx.renderer.border.Border(1, "solid", "#91A5BD"));
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
	},
	
	statics:
	{
		new_from_hash: function(name, data) {
			var tree = new ui.tree.Tree(name);
			tree.load_from_hash(data);
			return tree;
		}
	}
});
