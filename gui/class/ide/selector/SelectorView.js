qx.Class.define("ide.selector.SelectorView",
{
	extend: qx.ui.layout.VerticalBoxLayout,
	
	properties:
	{
		tree: { check: "ide.selector.fs.Tree" },
		toolbar: { check: "ide.selector.ToolBar" },
		versionstable: { check: "ide.selector.VersionsTable" },
		splitbox: { check: "qx.ui.splitpane.VerticalSplitPane" }
	},
	
	construct: function () {
		this.base(arguments);
		
		this.setEdge(0);
		this.set({height: "100%", width: "100%"});
		
		this.setToolbar(new ide.selector.ToolBar());
		this.add(this.getToolbar());
		
		this.setTree(new ide.selector.fs.Tree());
		this.setVersionstable(new ide.selector.VersionsTable());
		
		this.setSplitbox(new qx.ui.splitpane.VerticalSplitPane("3*", "2*"));
		with(this.getSplitbox()) {
			set({height: "100%", width: "100%"});
			addTop(this.getTree());
			addBottom(this.getVersionstable());
		}
		this.add(this.getSplitbox());
	},
	
	members:
	{
		set_tree_version: function(version){
			this.getSplitbox().getTopArea().remove(this.getTree());
			/*
			 * TODO: se deben borrar los FileTree del view?
			 *
			 * this.getTree().dispose();
			 * 
			 */
			this.setTree(new ide.selector.fs.Tree(version));
			this.getTree().load();
			this.getSplitbox().addTop(this.getTree());
		}
	}
});
