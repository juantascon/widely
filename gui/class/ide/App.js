qx.Class.define("ide.App",
{
	extend : qx.application.Gui,
	
	include: lib.dao.Auth,
	
	properties:
	{
		frame: { check: "qx.ui.layout.DockLayout" }
	},
	
	members:
	{
		main: function(e) {
			this.base(arguments);
			
			qx.Class.createNamespace("cons.WC", -1);
			
			qx.Class.createNamespace("global.statusbar", new lib.ui.StatusBar);
			qx.Class.createNamespace("global.editorview", new ide.editor.EditorView);
			qx.Class.createNamespace("global.selectorview", new ide.selector.SelectorView);
			
			qx.Class.createNamespace("global.session.id", -1);
			qx.Class.createNamespace("global.session.user", "test");
			
			var split_box = new qx.ui.splitpane.HorizontalSplitPane(300, "1*");
			split_box.addRight(global.editorview);
			split_box.addLeft(global.selectorview);
			
			var frame = new qx.ui.layout.DockLayout()
			with(frame) {
				set({left: 0, top: 0, height: "100%", width: "100%"});
				addBottom(global.statusbar);
				add(split_box);
			}
			
			qx.ui.core.ClientDocument.getInstance().add(frame);
			
			var login_rq = this.dao_login(global.session.user, global.session.user);
			login_rq.addEventListener("ok", function(e){
				global.session.id = e.getData();
				this.dao_set_wc("project1-wc1");
			}, this);
		},
		
		close: function(e) { this.base(arguments); },
		
		terminate: function(e) { this.base(arguments); }
	}
});
