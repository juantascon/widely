qx.Class.define("ui.editor.EditorView",
{
	type: "singleton",
	
	extend: qx.ui.layout.VerticalBoxLayout,
	
	construct: function () {
		this.base(arguments);
		main.Obj.editor = this;
		
		this.set({height: "100%", width: "100%"});
		
		this.setTabview(new ui.editor.TabView());
		//this.getTabview().add_tab(new ui.tree.File("file1", "/file1"));
		this.setToolbar(new ui.editor.ToolBar());
		
		this.add(this.getToolbar());
		this.add(this.getTabview());
	},
	
	properties:
	{
		tabview: { check: "ui.editor.TabView" },
		toolbar: { check: "ui.editor.ToolBar" }
	}
});
