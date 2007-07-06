qx.Class.define("ide.editor.EditorView",
{
	extend: qx.ui.layout.VerticalBoxLayout,
	
	properties:
	{
		tabview: { check: "ide.editor.TabView" },
		toolbar: { check: "ide.editor.ToolBar" }
	},
	
	construct: function () {
		this.base(arguments);
		
		this.set({height: "100%", width: "100%"});
		
		this.setTabview(new ide.editor.TabView());
		this.setToolbar(new ide.editor.ToolBar());
		
		this.add(this.getToolbar());
		this.add(this.getTabview());
	}
});
