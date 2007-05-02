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
			var frame = qx.ui.core.ClientDocument.getInstance();
			var main_box = new qx.ui.splitpane.HorizontalSplitPane("1*", "4*");
			main_box.set({left: 0, right: 0, top: 0, bottom: 0});
			main_box.setEdge(0);
			
			main_box.addLeft(tree.TreeView.getInstance());
			main_box.addRight(editor.EditorView.getInstance());
			
			frame.add(main_box);
			//frame.debug("HOLA: "+qx.io.JSON.stringify({data: "hola; bien&?", path: "/etc/init.d"}));
		},
		
		finalize: function(e) {},
		
		close: function(e) {},
		
		terminate: function(e) {}
	},
	
	settings: { "main.resourceUri": "./resource" }
});
