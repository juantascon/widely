qx.Class.define("editor.FileToolBar",
{
	type: "singleton",
	extend: qx.ui.layout.HorizontalBoxLayout,
	construct: function () {
		qx.ui.layout.HorizontalBoxLayout.call(this);
		
		this.setBorder(new qx.renderer.border.Border(1, "solid", "#91A5BD"));
		this.setMinHeight("auto");
		
		var b = new qx.ui.toolbar.Button("Save", "icon/22/actions/document-save.png");
		var c = new qx.ui.toolbar.Button("Reload", "icon/22/actions/view-refresh.png");
		this.add(b);
		this.add(c);
	}
});
