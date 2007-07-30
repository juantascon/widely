qx.Class.define("ide.selector.ToolBar",
{
	extend: lib.ui.toolbar.Horizontal,
	
	construct: function () {
		this.base(arguments, 22);
		
		this.add_part([
			{
				type: "button", permanent: false,
				label: "New File",icon: "actions/document-new",
				execute: function(e){
					global.selectorview.getTree().new_file(false);
				}
			},
			{
				type: "button", permanent: false,
				label: "New Dir",icon: "actions/folder-new",
				execute: function(e){
					global.selectorview.getTree().new_file(true);
				}
			},
			{
				type: "button", permanent: false,
				label: "Delete",icon: "actions/edit-delete",
				execute: function(e){
					global.selectorview.getTree().delete_selected();
				}
			}
		]);
		
		this.add_part([
			{
				type: "button", permanent: false,
				label: "Commit",icon: "actions/go-down",
				execute: function(e){
					global.selectorview.getTree().commit();
				}
			}
		]);
		
		this.add_part([
			{
				type: "button", permanent: true,
				label: "Reload",icon: "actions/view-refresh",
				execute: function(e){
					global.selectorview.getVersionstable().load();
				}
			}
		]);
		
		this.set_mode_ro(true);
	}
});
