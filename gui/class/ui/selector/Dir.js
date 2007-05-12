qx.Class.define("ui.selector.Dir",
{
	extend: qx.ui.tree.TreeFolder,
	
	include: dao.Dir,
	
	construct: function (name, path) {
		this.base(arguments, name);
		
		this.setName(name);
		this.setPath(path);
	},
	
	statics:
	{
		new_from_hash: function(h){
			var dir = new ui.selector.Dir(h["text"], h["id"]);
			
			if ( h["childs"] ) {
				for (var i in h["childs"]) {
					
					if (h["childs"][i]["type"] == "dir"){
						dir.addToFolder(ui.selector.Dir.new_from_hash(h["childs"][i]));
					}
					if (h["childs"][i]["type"] == "file"){
						dir.addToFolder(ui.selector.File.new_from_hash(h["childs"][i]));
					}
				}
			}
			
			return dir;
		}
	}
});
