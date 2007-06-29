qx.Class.define("ide.editor.ToolBar",
{
	extend: lib.ui.ToolBar,
	
	construct: function () {
		this.base(arguments);
		
		this.add_button("Reload", "actions/view-refresh", true, function(e){
			//TODO: terminar aqui
			//gloabl.editorview.getTabview().selected_tab().getFile().dao_load();
		});
		
		this.add_button("Save", "actions/document-save", false, function(e){
			//TODO: terminar aqui
			//global.editorview.getTabview().selected_tab().getFile().dao_save();
		});
		
		this.set_read_only_mode(true);
	}
});
