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
			var frame = new qx.ui.layout.CanvasLayout;
			var left_box = new qx.ui.splitpane.VerticalSplitPane("1*", "1*");
			left_box.setEdge(0);
			var main_box = new qx.ui.splitpane.HorizontalSplitPane("1*", "3*");
			main_box.setEdge(0);
			
			left_box.addTop(tree.TreeView.getInstance());
			//left_box.addBottom(ctags);
			
			main_box.addLeft(left_box);
			main_box.addRight(editor.EditorView.getInstance());
			
			with(frame)
			{
				setLocation(0, 0);
				setBottom(0);
				setRight(0);
				setPadding(2);
				add(main_box);
				addToDocument();
			}
		},
		
		finalize: function(e) {},
		
		close: function(e){},
		
		terminate: function(e) {}
	},
		
	settings: { "main.resourceUri": "./resource" }
});

