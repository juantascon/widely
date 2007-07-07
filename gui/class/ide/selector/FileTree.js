qx.Class.define("ide.selector.FileTree",
{
	extend: qx.ui.tree.Tree,
	
	include: [ ide.selector.FSDragAndDrop ],
	
	construct: function (version) {
		if (qx.util.Validation.isInvalid(eval(version))) { version = cons.WC }
		this.initialize_fs_object("/", "", eval(version));
		
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
		if (! this.is_read_only()) { this.set_fs_dropable(); }
	},
	
	members:
	{
		load_from_hash: function(data) {
			this.destroyContent();
			
			for (var i in data){
				data[i]["version"] = this.getVersion();
				
				if (data[i]["type"] == "dir"){
					this.addToFolder(ide.selector.Dir.new_from_hash(data[i]));
				}
				if (data[i]["type"] == "file"){
					this.addToFolder(ide.selector.File.new_from_hash(data[i]));
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
			var load_rq = this.wc_ls("/", this.getVersion());
			load_rq.addEventListener("ok", function(e) {
				this.load_from_hash(e.getData());
			}, this);
		},
		
		new_file: function() {
			var dir_d = new lib.ui.dialog.WCDirDialog("New File", "Where?");
			dir_d.addEventListener("ok", function(e) {
				var path = dir_d.selected_path();
				var selected = this.find_child_by_path(path);
				
				var name_d = new lib.ui.dialog.InputDialog("New File", "New file name:");
				name_d.addEventListener("ok", function(e) {
					var name = name_d.get_text();
					
					var add_rq = this.wc_add(path+name, false);
					add_rq.addEventListener("ok", function(e) {
						this.load();
					}, this);
				}, this);
				
			}, this);
		}
	}
});
