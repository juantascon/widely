qx.Class.define("ui.selector.ToolBar",
{
	extend: qx.ui.layout.HorizontalBoxLayout,
	
	construct: function () {
		this.base(arguments);
		
		this.setBorder(new qx.renderer.border.Border(1, "solid", "#91A5BD"));
		this.setMinHeight("auto");
		
		this.add_button("New File", "actions/document-new", function(e){
			var dir_d = new ui.component.WCDirDialog("New File", "Where?");
			dir_d.addEventListener("ok", function(e) {
				
				var selected = main.Obj.selector.getFiletree().find_child_by_path(dir_d.selected_dir().getPath());
				
				var name_d = new ui.component.InputDialog("New File", "New file name:");
				name_d.addEventListener("ok", function(e) {
					selected.add(new ui.selector.File(name_d.get_text(), selected.getPath()));
					main.Obj.selector.getFiletree().add_(selected.getPath()+name_d.get_text());
					
				});
				
			});
		});
		
		this.add_button("Delete", "actions/edit-delete", function(e){
			var selected = main.Obj.selector.getFiletree().getSelectedElement();
			var d = new ui.component.YesNoDialog("Delete", "Are you sure want to delele: "+selected.getPath());
			d.addEventListener("ok", function(e) {
				selected.delete_();
				selected.destroy();
			});
		});
		
		this.add_button("Reload", "actions/view-refresh", function(e){
			main.Obj.selector.getFiletree().load();
		});
		
		this.add_button("Commit", "actions/go-down", function(e){
			main.Obj.selector.getFiletree().commit();
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
