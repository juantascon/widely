qx.Class.define("ui.tree.ToolBar",
{
	extend: qx.ui.layout.HorizontalBoxLayout,
	
	construct: function () {
		this.base(arguments);
		
		this.setBorder(new qx.renderer.border.Border(1, "solid", "#91A5BD"));
		this.setMinHeight("auto");
		
		this.add_button("Reload", "actions/view-refresh", function(e){
			ui.tree.TreeView.getInstance().getTree().load();
		});
	},
	
	members:
	{
		add_button: function(label, icon, execute){
			var b = new qx.ui.toolbar.Button("Save", "icon/16/"+icon+".png");
			
			b.addEventListener("execute", execute);
			b.setToolTip(new qx.ui.popup.ToolTip(label));
			b.setShow("icon");
			
			this.add(b);
		}
	}
});
