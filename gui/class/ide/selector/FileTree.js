qx.Class.define("ide.selector.FileTree",
{
	extend: qx.ui.tree.Tree,
	
	include: [ lib.lang.Versioned, lib.dao.WC ],
	
	properties:
	{
		name: { check: "String", init: "/" },
		path: { check: "String", init: "/"}
	},
	
	construct: function (version) {
		this.setVersion(cons.WC);
		
		if (version) { this.setVersion(eval(version)); }
		
		if ( this.getVersion() == cons.WC ) {
			this.base(arguments, "WorkingCopy");
		}
		else {
			this.base(arguments, "Version: "+this.getVersion());
		}
		this.set({height: "100%", width: "100%"});
		this.setBackgroundColor("white");
		this.setOverflow("auto");
		//this.setBorder(new qx.renderer.border.Border(1, "solid", "#91A5BD"));
		
		this.setSelectedElement(this);
	},
	
	members:
	{
		load_from_hash: function(data, exclude_files) {
			this.destroyContent();
			
			for (var i in data){
				data[i]["version"] = this.getVersion();
				
				if (data[i]["type"] == "dir"){
					this.addToFolder(ide.selector.Dir.new_from_hash(data[i], exclude_files));
				}
				if (! exclude_files) {
					if (data[i]["type"] == "file"){
						this.addToFolder(ide.selector.File.new_from_hash(data[i]));
					}
				}
			}
		},
		
		find_child_by_path: function(path) {
			var items = this.getItems(true, true);
			
			for (var i in items) {
				if (items[i].getPath() == path) { return items[i]; }
			}
			
			return null;
		},
		
		load: function(){
			var load_rq = this.dao_ls("/", this.getVersion());
			load_rq.addEventListener("ok", function(e) {
				this.load_from_hash(e.getData(), false);
			}, this);
		}
	}
});
