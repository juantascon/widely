qx.Class.define("ui.selector.ToolBar",
{
	extend: qx.ui.layout.HorizontalBoxLayout,
	
	construct: function () {
		this.base(arguments);
		
		this.setBorder(new qx.renderer.border.Border(1, "solid", "#91A5BD"));
		this.setMinHeight("auto");
		
		this.add_button("Delete", "actions/edit-delete", function(e){
			var selected = ui.selector.View.getInstance().getFiletree().getSelectedElement();
			d = new ui.component.YesNoDialog("Delete", "Are you sure want to delele: "+selected.getPath());
			d.addEventListener("ok", function(e) {
				selected.delete_();
				selected.destroy();
			});
		});
		
		this.add_button("Reload", "actions/view-refresh", function(e){
			ui.selector.View.getInstance().getFiletree().load();
		});
		
		this.add_button("Commit", "actions/go-down", function(e){
			ui.selector.View.getInstance().getFiletree().commit();
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
