qx.Class.define("ide.editor.ToolBar",
{
	extend: lib.ui.toolbar.Horizontal,
	
	construct: function () {
		this.base(arguments, 22);
		
		this.add_part([
			{
				type: "button", permanent: false,
				label: "Save", icon: "actions/document-save",
				execute: function(e){
					global.editorview.getTabview().getSelected().save_file_content();
				}
			}
		]);
		
		this.add_part([
			{
				type: "button", permanent: true,
				label: "Reload", icon: "actions/view-refresh",
				execute: function(e){
					global.editorview.getTabview().getSelected().load_file_content();
				}
			}
		]);
		
		this.set_mode_disable(true);
	}
});
