qx.Class.define("ide.selector.ToolBar",
{
	extend: qx.ui.layout.HorizontalBoxLayout,
	
	construct: function () {
		this.base(arguments);
		
		this.setBorder(new qx.renderer.border.Border(1, "solid", "#91A5BD"));
		this.setMinHeight("auto");
		
		this.add_button("New File", "actions/document-new", function(e){
			ui.cmd.FileTree.new_file();
		});
		
		this.add_button("Delete", "actions/edit-delete", function(e){
			ui.cmd.FileTree.delete_selected();
		});
		
		this.add_button("Reload", "actions/view-refresh", function(e){
			core.Obj.selector.getFiletree().dao_load();
		});
		
		this.add_button("Commit", "actions/go-down", function(e){
			ui.cmd.FileTree.commit();
		});
	},
	
	members:
	{
		add_button: function(label, icon, execute){
			var b = new qx.ui.toolbar.Button(label, "icon/16/"+icon+".png");
			
			b.addEventListener("execute", execute);
			b.setToolTip(new qx.ui.popup.ToolTip(label));
			b.setShow("icon");
			
			this.add(b);
		}
	}
});
