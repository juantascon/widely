qx.Class.define("ide.selector.Dir",
{
	extend: qx.ui.tree.TreeFolder,
	
	include: [ ide.selector.FSDragAndDrop ],
	
	construct: function (name, path, version) {
		this.base(arguments, name);
		this.initialize_fs_object(name, path, version);
		
		if (! this.is_read_only()) {
			this.set_fs_dragable();
			this.set_fs_dropable();
		}
	},
	
	statics:
	{
		new_from_hash: function(h){
			var dir = new ide.selector.Dir(h["name"], h["path"], h["version"]);
			
			if ( h["childs"] ) {
				for (var i in h["childs"]) {
					h["childs"][i]["version"] = h["version"];
					
					if (h["childs"][i]["type"] == "dir"){
						dir.addToFolder(ide.selector.Dir.new_from_hash(h["childs"][i]));
					}
					if (h["childs"][i]["type"] == "file"){
						dir.addToFolder(ide.selector.File.new_from_hash(h["childs"][i]));
					}
				}
			}
			
			return dir;
		}
	}
});
