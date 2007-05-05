qx.Class.define("main.Widely",
{
	extend: qx.component.AbstractApplication,
	construct : function() {
		qx.component.AbstractApplication.call(this);
	},
	
	members:
	{
		initialize: function(e){
		},
		
		main: function(e) {
			var frame = new qx.ui.layout.DockLayout();
			frame.setEdge(0);
			
			var main_box = new qx.ui.splitpane.HorizontalSplitPane(200, "1*");
			with(main_box) {
				//main_box.setHeight("1*");
				addLeft(tree.TreeView.getInstance());
				addRight(editor.EditorView.getInstance());
			}
			
			var l = new qx.ui.basic.Label("hola", "h1");
			l.setMinHeight("auto");
			
			var lc = new qx.ui.layout.CanvasLayout();
			lc.setHeight("auto");
			lc.add(l);
			
			frame.add(main_box);
			frame.addBottom(lc);
			
			frame.addToDocument();
		},
		
		finalize: function(e) {},
		
		close: function(e) {},
		
		terminate: function(e) {}
	},
	
	settings: { "main.resourceUri": "./resource" }
});
