qx.Class.define("ui.selector.FileTree",
{
	extend: qx.ui.tree.Tree,
	
	include: dao.Tree,
	
	construct: function (version) {
		if (version) { this.setVersion(eval(version)); }
		
		if ( this.getVersion() == main.Cons.WC ) {
			this.base(arguments, "WorkingCopy");
		}
		else {
			this.base(arguments, "Version: "+this.getVersion());
		}
		this.set({height: "100%", width: "100%"});
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
					this.addToFolder(ui.selector.Dir.new_from_hash(data[i]));
				}
				if (data[i]["type"] == "file"){
					this.addToFolder(ui.selector.File.new_from_hash(data[i]));
				}
			}
			this.setSelectedElement(this);
		}
	}
});
