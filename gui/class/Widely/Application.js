
qx.OO.defineClass("Widely.Application", qx.component.AbstractApplication,
function () {
	qx.component.AbstractApplication.call(this);
});

qx.Settings.setDefault("resourceUri", "./resource");

qx.Proto.initialize = function(e)
{
	// Define alias for custom resource path
	qx.manager.object.AliasManager.getInstance().add("Widely", qx.Settings.getValueOfClass("Widely.Application", "resourceUri"));
};

qx.Proto.main = function(e)
{
	var frame = new qx.ui.layout.CanvasLayout;
	frame.setLocation(0, 0);
	frame.setBottom(0);
	frame.setRight(0);
	frame.setPadding(10);
	frame.addToDocument();

	// the splitpane itself
	var splitpane = new qx.ui.splitpane.HorizontalSplitPane("1*", "2*");
	splitpane.setEdge(0);
	splitpane.setLiveResize(true);
	frame.add(splitpane);
	
	var editor = new Widely.Editor;
	splitpane.addRight(tf1);
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
