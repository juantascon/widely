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
			
			with(main_box.getFirstArea())
			{
				setLocation(0, 0);
				setBottom(0);
				setRight(0);
				setPadding(2);
			}
			with(main_box.getSecondArea())
			{
				setLocation(0, 0);
				setBottom(0);
				setTop(0);
				setPadding(2);
			}
			frame.add(main_box);
		},
		
		finalize: function(e) {},
		
		close: function(e) {},
		
		terminate: function(e) {}
	},
	
	settings: { "main.resourceUri": "./resource" }
});
