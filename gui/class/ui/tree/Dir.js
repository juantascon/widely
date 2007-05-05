qx.Class.define("ui.tree.Dir",
{
	extend: qx.ui.tree.TreeFolder,
	
	include: dao.Dir,
	
	construct: function (name) {
		qx.ui.tree.TreeFolder.call(this, name);
	},
	
	statics:
	{
		new_from_hash: function(h){
			var dir = new ui.tree.Dir(h["text"]);
			
			if ( h["childs"] ) {
				for (var i in h["childs"]) {
					if (h["childs"][i]["type"] == "dir"){
						dir.addToFolder(ui.tree.Dir.new_from_hash(h["childs"][i]));
					}
					if (h["childs"][i]["type"] == "file"){
						dir.addToFolder(ui.tree.File.new_from_hash(h["childs"][i]));
					}
				}
			}
			
			return dir;
		}
	}
});
