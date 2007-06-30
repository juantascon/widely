qx.Class.define("ide.editor.ToolBar",
{
	extend: lib.ui.ToolBar,
	
	construct: function () {
		this.base(arguments);
		
		this.add_button("Reload", "actions/view-refresh", true, function(e){
			global.editorview.getTabview().getSelected().load_file_content();
		});
		
		this.add_button("Save", "actions/document-save", false, function(e){
			global.editorview.getTabview().getSelected().save_file_content();
		});
		
		this.set_disabled_mode(true);
	}
});
