qx.Class.define("editor.EditorView",
{
	type: "singleton",
	extend: qx.ui.layout.VerticalBoxLayout,
	construct: function () {
		qx.ui.layout.VerticalBoxLayout.call(this);
		var _this = this;
		
		this.setEdge(0);
		this.set({left: 0, right: 0, top: 0, bottom: 0});
		this.setHeights("100%");
		this.setWidths("100%");
		
		this.setTabview(new editor.TabView());
		this.getTabview().add_tab(new tree.File("file1", "/file1"));
		this.setFiletoolbar(new editor.FileToolBar());
		
		this.add(this.getFiletoolbar());
		this.add(this.getTabview());
	},
	
	properties:
	{
		tabview: { check: "editor.TabView" },
		filetoolbar: { check: "editor.FileToolBar" }
	}
});
