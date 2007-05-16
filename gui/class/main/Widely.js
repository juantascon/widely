qx.Class.define("main.Widely",
{
	extend : qx.application.Gui,
	
	construct : function() {
		this.base(arguments);
	},
	
	members:
	{
		main: function(e) {
			this.base(arguments);
			
			main.Obj.statusbar = ui.StatusBar.getInstance();
			main.Obj.editor = ui.editor.EditorView.getInstance();
			main.Obj.selector = ui.selector.View.getInstance();
			
			var frame = new qx.ui.layout.DockLayout();
			frame.setEdge(0);
			
			frame.addBottom(main.Obj.statusbar);
			
			var split_box = new qx.ui.splitpane.HorizontalSplitPane(300, "1*");
			split_box.addRight(main.Obj.editor);
			split_box.addLeft(main.Obj.selector);
			frame.add(split_box);
			
			qx.ui.core.ClientDocument.getInstance().add(frame);
		},
		
		close: function(e) { this.base(arguments); },
		
		terminate: function(e) { this.base(arguments); }
	},
	
	settings:
	{
		"main.resourceUri": "./resource"
	}
});
