qx.OO.defineClass("tree.Dir", qx.ui.treefullcontrol.TreeFolder,
function (name) {
	qx.ui.treefullcontrol.TreeFolder.call(this, this.trs.standard(name));
});

qx.Proto.trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance();

qx.Clazz.new_from_hash = function(h){
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
};
