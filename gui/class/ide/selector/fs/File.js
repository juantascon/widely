qx.Class.define("ide.selector.fs.File",
{
	extend: qx.ui.tree.TreeFile,
	
	include: [ ide.selector.fs.DragAndDrop ],
	
	construct: function (name, path, version) {
		this.base(arguments, name);
		this.setFtype("file");
		this.initialize_fs_object(name, path, version);
		
		this.addEventListener("click", function(e){
			global.editorview.getTabview().add_tab(this);
		}, this);
		
		if (! this.is_read_only()) {
			this.set_fs_dragable();
			this.set_fs_renameable();
		}
	},
	
	statics:
	{
		new_from_hash: function(h){
			return new ide.selector.fs.File(h["name"], h["path"], h["version"]);
		}
		
	}
});
