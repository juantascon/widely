qx.Class.define("ide.App",
{
	extend : qx.application.Gui,
	
	include: lib.dao.api.Auth,
	
	members:
	{
		main: function(e) {
			this.base(arguments);
			
			qx.Class.createNamespace("cons.WC", -1);
			
			qx.Class.createNamespace("global.mainframe", new qx.ui.layout.DockLayout);
			qx.Class.createNamespace("global.statusbar", new lib.ui.StatusBar);
			qx.Class.createNamespace("global.editorview", new ide.editor.EditorView);
			qx.Class.createNamespace("global.selectorview", new ide.selector.SelectorView);
			
			qx.Class.createNamespace("global.session.id", -1);
			qx.Class.createNamespace("global.session.user", "test");
			
			var split_box = new qx.ui.splitpane.HorizontalSplitPane(300, "1*");
			split_box.addRight(global.editorview);
			split_box.addLeft(global.selectorview);
			
			with(global.mainframe) {
				set({left: 0, top: 0, height: "100%", width: "100%"});
				addBottom(global.statusbar);
				add(split_box);
			}
			
			qx.ui.core.ClientDocument.getInstance().add(global.mainframe);
			
			var login_rq = this.auth_login(global.session.user, global.session.user);
			login_rq.addEventListener("ok", function(e){
				global.session.id = e.getData();
				var set_wc_rq = this.auth_set_wc("project1-wc1");
				set_wc_rq.addEventListener("ok", function(e){
					global.selectorview.getVersionstable().load();
				});
			}, this);
		},
		
		close: function(e) { this.base(arguments); },
		
		terminate: function(e) { this.base(arguments); }
	}
});
