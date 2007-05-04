qx.Class.define("editor.FileToolBar",
{
	extend: qx.ui.layout.HorizontalBoxLayout,
	construct: function () {
		qx.ui.layout.HorizontalBoxLayout.call(this);
		
		this.setBorder(new qx.renderer.border.Border(1, "solid", "#91A5BD"));
		this.setMinHeight("auto");
		
		this.add_button("Save", "actions/document-save", function(e){
			editor.EditorView.getInstance().getTabview().selected_tab().getFile().save();
		});
		
		this.add_button("Reload", "actions/view-refresh", function(e){
			editor.EditorView.getInstance().getTabview().selected_tab().getFile().load();
		});
	},
	
	members:
	{
		add_button: function(label, icon, execute){
			var b = new qx.ui.toolbar.Button("Save", "icon/22/"+icon+".png");
			b.addEventListener("execute", execute);
			b.setToolTip(new qx.ui.popup.ToolTip(label));
			b.setShow("icon");
			this.add(b);
		}
	}
});
