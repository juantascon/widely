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
			
			frame.addBottom(ui.StatusBar.getInstance());
			
			var split_box = new qx.ui.splitpane.HorizontalSplitPane(300, "1*");
			split_box.addRight(ui.editor.EditorView.getInstance());
			split_box.addLeft(ui.selector.View.getInstance());
			frame.add(split_box);
			
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
