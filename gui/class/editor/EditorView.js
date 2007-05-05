qx.Class.define("editor.EditorView",
{
	type: "singleton",
	extend: qx.ui.layout.VerticalBoxLayout,
	construct: function () {
		qx.ui.layout.VerticalBoxLayout.call(this);
		
		this.set({height: "100%", width: "100%"});
		
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
