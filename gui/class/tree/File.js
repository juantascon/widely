qx.OO.defineClass("tree.File", qx.ui.treefullcontrol.TreeFile,
function (name) {
	this.inode = tree.File.next_inode++;
	
	this.setName(name);
	qx.ui.treefullcontrol.TreeFile.call(this, this.trs.standard(name, this.icon));
});

qx.Proto.trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance();
qx.Proto.icon = "icon/16/mimetypes/text-ascii.png";

qx.OO.addProperty({ name : "name", type : "string", defaultValue : "" });

qx.Clazz.new_from_hash = function(h){
	return new tree.File(h["text"]);
};

qx.Clazz.next_inode = 0;
