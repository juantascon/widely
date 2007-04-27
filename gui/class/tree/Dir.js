qx.Class.define("tree.Dir",
{
	extend: qx.ui.tree.TreeFolder,
	construct: function (name) {
		qx.ui.tree.TreeFolder.call(this, name);
	},
	
	statics:
	{
		new_from_hash: function(h){
			var dir = new tree.Dir(h["text"]);
			
			if ( h["childs"] ) {
				for (var i in h["childs"]) {
					if (h["childs"][i]["type"] == "dir"){
						dir.addToFolder(tree.Dir.new_from_hash(h["childs"][i]));
					}
					if (h["childs"][i]["type"] == "file"){
						dir.addToFolder(tree.File.new_from_hash(h["childs"][i]));
					}
				}
			}
			
			return dir;
		}
	}
});
