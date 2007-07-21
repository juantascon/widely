qx.Class.define("ide.selector.ToolBar",
{
	extend: lib.ui.ToolBar,
	
	construct: function () {
		this.base(arguments, "horizontal", 16);
		
		this.add_button("Reload", "actions/view-refresh", true, function(e){
			global.selectorview.getVersionstable().load();
		});
		
		this.add_button("New File", "actions/document-new", false, function(e){
			global.selectorview.getTree().new_file(false);
		});
		
		this.add_button("New Dir", "actions/folder-new", false, function(e){
			global.selectorview.getTree().new_file(true);
		});
		
		this.add_button("Delete", "actions/edit-delete", false, function(e){
			
		});
		
		
		this.add_button("Commit", "actions/go-down", false, function(e){
			
		});
		this.set_mode_ro(true);
	}
});
