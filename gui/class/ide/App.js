qx.Class.define("ide.App",
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
			
			core.Obj.statusbar = ui.StatusBar.getInstance();
			core.Obj.editor = ui.editor.EditorView.getInstance();
			core.Obj.selector = ui.selector.View.getInstance();
			
			this.setFrame(new qx.ui.layout.DockLayout());
			this.getFrame().setEdge(0);
			
			this.getFrame().addBottom(core.Obj.statusbar);
			
			var split_box = new qx.ui.splitpane.HorizontalSplitPane(300, "1*");
			split_box.addRight(core.Obj.editor);
			split_box.addLeft(core.Obj.selector);
			this.getFrame().add(split_box);
			
			qx.ui.core.ClientDocument.getInstance().add(this.getFrame());
			
			var login = new core.Login();
			login.start();
		},
		
		
		close: function(e) { this.base(arguments); },
		
		terminate: function(e) { this.base(arguments); }
	},
	
	settings:
	{
		"apps.IDE.resourceUri": "./resource"
	}
});
