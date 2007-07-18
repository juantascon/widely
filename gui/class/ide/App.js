qx.Class.define("ide.App",
{
	extend: lib.WApp,
	
	members:
	{
		main: function(e) {
			this.base(arguments, "ide");
			
			this.init_session("user", function() {
				qx.Class.createNamespace("cons.WC", -1);
				
				qx.Class.createNamespace("global.editorview", new ide.editor.EditorView);
				qx.Class.createNamespace("global.selectorview", new ide.selector.SelectorView);
				
				var split_box = new qx.ui.splitpane.HorizontalSplitPane(300, "1*");
				split_box.addRight(global.editorview);
				split_box.addLeft(global.selectorview);
				
				global.mainframe.add(split_box);

				var set_wc_rq = this.auth_set_wc("project1-wc1");
				set_wc_rq.addEventListener("ok", function(e){
					global.selectorview.getVersionstable().load();
				});

				/* TODO: hacer un set_wc() cuando retorne hacer un:
				 * global.selectorview.getVersionstable().load();
				 */
			}, this);
		}
	}
});
