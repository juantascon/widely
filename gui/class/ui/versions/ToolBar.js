qx.Class.define("ui.versions.ToolBar",
{
	extend: qx.ui.layout.HorizontalBoxLayout,
	
	construct: function () {
		this.base(arguments);
		
		this.setBorder(new qx.renderer.border.Border(1, "solid", "#91A5BD"));
		this.setMinHeight("auto");
		
		this.add_button("Reload", "actions/view-refresh", function(e){
			ui.versions.VersionsView.getInstance().getVtable().load();
		});
		
		this.add_button("Load Tree", "actions/go-up", function(e){
			var selected_row_id = ui.versions.VersionsView.getInstance().getVtable().selected_row_id();
			ui.tree.TreeView.getInstance().change_tree_version(selected_row_id);
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
