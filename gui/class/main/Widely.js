qx.Class.define("main.Widely",
{
	extend: qx.component.AbstractApplication,
	
	construct : function() {
		this.base(arguments);
	},
	
	members:
	{
		initialize: function(e) {},
		
		main: function(e) {
			var frame = new qx.ui.layout.DockLayout();
			frame.setEdge(0);
			
			var split_tree = new qx.ui.splitpane.VerticalSplitPane("3*", "2*");
			split_tree.setEdge(0);
			split_tree.addTop(ui.tree.TreeView.getInstance());
			split_tree.addBottom(ui.versions.VersionsView.getInstance());
			
			var split_box = new qx.ui.splitpane.HorizontalSplitPane(300, "1*");
			split_box.addLeft(split_tree);
			split_box.addRight(ui.editor.EditorView.getInstance());
			
			frame.add(split_box);
			frame.addBottom(ui.StatusBar.getInstance());
			
			frame.addToDocument();
		},
		
		finalize: function(e) {},
		
		close: function(e) {},
		
		terminate: function(e) {}
	},
	
	settings:
	{
		"main.resourceUri": "./resource"
	}
});
