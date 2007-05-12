qx.Class.define("ui.selector.View",
{
	type: "singleton",
	
	extend: qx.ui.layout.VerticalBoxLayout,
	
	construct: function () {
		this.base(arguments);
		main.Obj.selector = this;
		
		this.setEdge(0);
		this.set({height: "100%", width: "100%"});
		
		this.setToolbar(new ui.selector.ToolBar());
		this.setSplitbox(new qx.ui.splitpane.VerticalSplitPane("3*", "2*"));
		this.setFiletree(new ui.selector.FileTree(-1));
		this.setVmtable(new ui.selector.VMTable());
		
		with(this.getSplitbox()) {
			set({height: "100%", width: "100%"});
			addTop(this.getFiletree());
			addBottom(this.getVmtable());
		}
		
		this.add(this.getToolbar());
		this.add(this.getSplitbox());
	},
	
	properties:
	{
		filetree: { check: "ui.selector.FileTree" },
		toolbar: { check: "ui.selector.ToolBar" },
		vmtable: { check: "ui.selector.VMTable" },
		splitbox: { check: "qx.ui.splitpane.VerticalSplitPane" }
	},
	
	members:
	{
		set_version: function(version){
			this.getSplitbox().getTopArea().remove(this.getFiletree());
			//this.getFiletree().dispose();
			this.setFiletree(new ui.selector.FileTree(version));
			this.getSplitbox().addTop(this.getFiletree());
		}
	}
});
