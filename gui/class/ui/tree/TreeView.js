qx.Class.define("ui.tree.TreeView",
{
	type: "singleton",
	
	extend: qx.ui.layout.VerticalBoxLayout,
	
	construct: function () {
		qx.ui.layout.VerticalBoxLayout.call(this);
		this.set({height: "100%", width: "100%"});
		
		this.setToolbar(new ui.tree.ToolBar());
		this.add(this.getToolbar());
		
		this.setTree(new ui.tree.Tree("/"));
	},
	
	properties:
	{
		tree: { check: "qx.ui.tree.Tree", apply: "change_tree" },
		toolbar: { check: "ui.tree.ToolBar" }
	},
	
	members:
	{
		change_tree: function(newValue, oldValue) {
			if (oldValue) {
				oldValue.destroyContent();
				oldValue.dispose();
				this.remove(oldValue);
			}
			this.add(newValue);
		}
	}
});
