qx.Class.define("ide.selector.SelectorView",
{
	extend: qx.ui.layout.VerticalBoxLayout,
	
	construct: function () {
		this.base(arguments);
		
		this.setEdge(0);
		this.set({height: "100%", width: "100%"});
		
		this.setToolbar(new ide.selector.ToolBar());
		this.add(this.getToolbar());
		
		this.setFiletree(new ide.selector.FileTree());
		this.setVersionstable(new ide.selector.VersionsTable());
		
		this.setSplitbox(new qx.ui.splitpane.VerticalSplitPane("3*", "2*"));
		with(this.getSplitbox()) {
			set({height: "100%", width: "100%"});
			addTop(this.getFiletree());
			addBottom(this.getVersionstable());
		}
		this.add(this.getSplitbox());
	},
	
	properties:
	{
		filetree: { check: "ide.selector.FileTree" },
		toolbar: { check: "ide.selector.ToolBar" },
		versionstable: { check: "ide.selector.VersionsTable" },
		splitbox: { check: "qx.ui.splitpane.VerticalSplitPane" }
	},
	
	members:
	{
		set_filetree_version: function(version){
			this.getSplitbox().getTopArea().remove(this.getFiletree());
			/*
			 * TODO: se deben borrar los FileTree del view?
			 *
			 * this.getFiletree().dispose();
			 * 
			 */
			this.setFiletree(new ide.selector.FileTree(version));
			this.getFiletree().load();
			this.getSplitbox().addTop(this.getFiletree());
		}
	}
});
