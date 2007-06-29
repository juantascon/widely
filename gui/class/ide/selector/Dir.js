qx.Class.define("ide.selector.Dir",
{
	extend: qx.ui.tree.TreeFolder,
	
	include: [ lib.lang.Versioned, lib.dao.WC ],
	
	properties:
	{
		name: { check: "String", init: "" },
		path: { check: "String", init: ""}
	},
	
	construct: function (name, path, version) {
		this.base(arguments, name);
		
		this.setName(name);
		this.setPath(path);
		this.setVersion(version);
	},
	
	statics:
	{
		new_from_hash: function(h, exclude_files){
			var dir = new ide.selector.Dir(h["text"], h["id"], h["version"]);
			
			if ( h["childs"] ) {
				for (var i in h["childs"]) {
					h["childs"][i]["version"] = h["version"];
					
					if (h["childs"][i]["type"] == "dir"){
						dir.addToFolder(ide.selector.Dir.new_from_hash(h["childs"][i], exclude_files));
					}
					
					if (! exclude_files) {
						if (h["childs"][i]["type"] == "file"){
							dir.addToFolder(ide.selector.File.new_from_hash(h["childs"][i]));
						}
					}
				}
			}
			
			return dir;
		}
	}
});
