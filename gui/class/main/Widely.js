qx.Class.define("main.Widely",
{
	extend: qx.component.AbstractApplication,
	
	construct : function() {
		qx.component.AbstractApplication.call(this);
	},
	
	members:
	{
		initialize: function(e) {},
		
		main: function(e) {
			var frame = new qx.ui.layout.DockLayout();
			frame.setEdge(0);
			
			var split_box = new qx.ui.splitpane.HorizontalSplitPane(200, "1*");
			split_box.addLeft(ui.tree.TreeView.getInstance());
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
