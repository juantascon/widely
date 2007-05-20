qx.Class.define("main.Widely",
{
	extend : qx.application.Gui,
	
	construct : function() {
		this.base(arguments);
	},
	
	properties:
	{
		frame: { check: "qx.ui.layout.DockLayout" }
	},
	
	members:
	{
		main: function(e) {
			this.base(arguments);
			
			main.Obj.statusbar = ui.StatusBar.getInstance();
			main.Obj.editor = ui.editor.EditorView.getInstance();
			main.Obj.selector = ui.selector.View.getInstance();
			
			this.setFrame(new qx.ui.layout.DockLayout());
			this.getFrame().setEdge(0);
			
			this.getFrame().addBottom(main.Obj.statusbar);
			
			var split_box = new qx.ui.splitpane.HorizontalSplitPane(300, "1*");
			split_box.addRight(main.Obj.editor);
			split_box.addLeft(main.Obj.selector);
			this.getFrame().add(split_box);
			
			qx.ui.core.ClientDocument.getInstance().add(this.getFrame());
			
			var login = new main.Login();
			login.start();
		},
		
		
		close: function(e) { this.base(arguments); },
		
		terminate: function(e) { this.base(arguments); }
	},
	
	settings:
	{
		"main.resourceUri": "./resource"
	}
});
