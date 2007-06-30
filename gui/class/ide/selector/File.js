qx.Class.define("ide.selector.File",
{
	extend: qx.ui.tree.TreeFile,
	
	include: [ ide.selector.FSObject, ide.selector.FSDragAndDrop, lib.dao.WC ],
	
	construct: function (name, path, version) {
		this.base(arguments, name);
		this.initialize_fs_object(name, path, version);
		
		this.addEventListener("click", function(e){
			global.editorview.getTabview().add_tab(this);
		}, this);
		
		this.set_fs_dragable();
	},
	
	statics:
	{
		new_from_hash: function(h){
			return new ide.selector.File(h["name"], h["path"], h["version"]);
		}
		
	}
});
