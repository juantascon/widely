qx.Class.define("ui.editor.EditorView",
{
	type: "singleton",
	
	extend: qx.ui.layout.VerticalBoxLayout,
	
	construct: function () {
		qx.ui.layout.VerticalBoxLayout.call(this);
		
		this.set({height: "100%", width: "100%"});
		
		this.setTabview(new ui.editor.TabView());
		this.getTabview().add_tab(new ui.tree.File("file1", "/file1"));
		this.setFiletoolbar(new ui.editor.FileToolBar());
		
		this.add(this.getFiletoolbar());
		this.add(this.getTabview());
	},
	
	properties:
	{
		tabview: { check: "ui.editor.TabView" },
		filetoolbar: { check: "ui.editor.FileToolBar" }
	}
});
