qx.Class.define("ide.App",
{
	extend: lib.WApp,
	
	members:
	{
		main: function(e) {
			this.base(arguments);
			
			this.init_wapp("ide", "user");
			this.init_mainframe();
			this.init_session();
		},
		
		init: function() {
			qx.Class.createNamespace("cons.WC", -1);
			
			qx.Class.createNamespace("global.editorview", new ide.editor.EditorView);
			qx.Class.createNamespace("global.selectorview", new ide.selector.SelectorView);
			qx.Class.createNamespace("global.toolbar", new ide.ToolBar);
			
			var split_box = new qx.ui.splitpane.HorizontalSplitPane(300, "1*");
			split_box.addRight(global.editorview);
			split_box.addLeft(global.selectorview);
			
			global.mainframe.add(split_box);
			global.mainframe.addTop(global.toolbar);
			
			// TODO: quitar esto
			var set_wc_rq = this.auth_set_wc("project1-wc1");
			set_wc_rq.addEventListener("ok", function(e){
				global.selectorview.getVersionstable().load();
			});
		}
	}
});
