qx.Class.define("ide.selector.fs.Dir",
{
	extend: qx.ui.tree.TreeFolder,
	
	include: [ ide.selector.fs.DragAndDrop ],
	
	construct: function (name, path, version) {
		this.base(arguments, name);
		this.setFtype("dir");
		this.initialize_fs_object(name, path, version);
		
		if (! this.is_read_only()) {
			this.set_fs_dragable();
			this.set_fs_dropable();
			this.set_fs_renameable();
		}
	},
	
	statics:
	{
		new_from_hash: function(h){
			var dir = new ide.selector.fs.Dir(h["name"], h["path"], h["version"]);
			
			if ( h["childs"] ) {
				for (var i in h["childs"]) {
					h["childs"][i]["version"] = h["version"];
					
					if (h["childs"][i]["type"] == "dir"){
						dir.addToFolder(ide.selector.fs.Dir.new_from_hash(h["childs"][i]));
					}
					if (h["childs"][i]["type"] == "file"){
						dir.addToFolder(ide.selector.fs.File.new_from_hash(h["childs"][i]));
					}
				}
			}
			
			return dir;
		}
	}
});
