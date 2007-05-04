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
			
			var main_box = new qx.ui.splitpane.HorizontalSplitPane("1*", "4*");
			with(main_box) {
				//setEdge(0);
				//set({left: 0, right: 0, top: 0, bottom: 0});
				//set({heights: "98%", widths: "auto"});
				addLeft(tree.TreeView.getInstance());
				addRight(editor.EditorView.getInstance());
			}
			
			var l = new qx.ui.basic.Label("hola", "h1");
			/*with(l) {
				//setEdge(0);
				//set({left: 0, right: 0, top: 0, bottom: 0});
				//set({heights: "100%", widths: "100%"});
			}*/
			frame.addLeft(main_box);
			frame.addBottom(l);
			frame.addToDocument();
		},
		
		finalize: function(e) {},
		
		close: function(e) {},
		
		terminate: function(e) {}
	},
	
	settings: { "main.resourceUri": "./resource" }
});
