qx.Class.define("ui.tree.TreeView",
{
	type: "singleton",
	
	extend: qx.ui.layout.VerticalBoxLayout,
	
	construct: function () {
		this.base(arguments);
		
		this.set({height: "100%", width: "100%"});
		
		this.setToolbar(new ui.tree.ToolBar());
		this.add(this.getToolbar());
		
		this.setTree(new ui.tree.Tree("/"));
		this.add(this.getTree());
	},
	
	properties:
	{
		tree: { check: "qx.ui.tree.Tree" },
		toolbar: { check: "ui.tree.ToolBar" }
	}
});
