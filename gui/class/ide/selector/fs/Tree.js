qx.Class.define("ide.selector.fs.Tree",
{
	extend: qx.ui.tree.Tree,
	
	include: [ ide.selector.fs.DragAndDrop ],
	
	construct: function (version) {
		if (qx.util.Validation.isInvalid(eval(version))) { version = cons.WC }
		this.initialize_fs_object("/", "", eval(version));
		
		if ( this.getVersion() == cons.WC ) {
			this.base(arguments, "WorkingCopy");
		}
		else {
			this.base(arguments, "Version: "+this.getVersion());
		}
		
		this.setFtype("dir");
		
		this.set({height: "100%", width: "100%"});
		this.setBackgroundColor("white");
		this.setOverflow("auto");
		//this.setBorder(new qx.renderer.border.Border(1, "solid", "#91A5BD"));
		
		this.setSelectedElement(this);
		if (! this.is_read_only()) {
			this.set_fs_dropable();
		}
	},
	
	members:
	{
		load_from_hash: function(data) {
			this.destroyContent();
			
			for (var i in data){
				data[i]["version"] = this.getVersion();
				
				if (data[i]["type"] == "dir"){
					this.addToFolder(ide.selector.fs.Dir.new_from_hash(data[i]));
				}
				if (data[i]["type"] == "file"){
					this.addToFolder(ide.selector.fs.File.new_from_hash(data[i]));
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
		
		new_file: function(as_dir) {
			var dir = null;
			var selected = this.getSelectedElement();
			if (selected.getFtype() == "dir") {
				dir = selected;
			}
			else {
				dir = selected.getParentFolder();
			}
			
			var name_popup = new lib.ui.popupdialog.Input(dir, "new");
			name_popup.addEventListener("ok", function(e) {
				var name = name_popup.get_text();
				var path = dir.full_name();
				
				var add_rq = this.wc_add(path+"/"+name, as_dir);
				add_rq.addEventListener("ok", function(e) {
					if (as_dir) {
						dir.addToFolder(new ide.selector.fs.Dir(name, path, this.getVersion()));
					}
					else {
						dir.addToFolder(new ide.selector.fs.File(name, path, this.getVersion()));
					}
				}, this);
				add_rq.addEventListener("fail", function(e) {
					new lib.ui.popupdialog.Atom(dir, e.getData());
				}, this);
			}, this);
		}
	}
});
