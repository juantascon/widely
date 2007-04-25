qx.OO.defineClass("Main", qx.component.AbstractApplication,
function () {
	qx.component.AbstractApplication.call(this);
});

qx.Settings.setDefault("resourceUri", "./resource");

qx.Proto.initialize = function(e)
{
};

qx.Proto.main = function(e)
{
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
};

qx.Proto.finalize = function(e)
{
  // After initial rendering...
};

qx.Proto.close = function(e)
{
  // Prompt user
  // e.returnValue = "[qooxdoo application: Do you really want to close the application?]";
};

qx.Proto.terminate = function(e)
{
  // alert("terminated");
};
