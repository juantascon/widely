qx.Class.define("lib.ui.toolbar.Vertical",
{
	extend: qx.ui.layout.VerticalBoxLayout,
	
	include: lib.ui.toolbar.ToolBar,
	
	construct: function(iconsize) {
		this.base(arguments);
		
		this.initialize_toolbar(iconsize);
		this.set({height: null, width: "auto"});
	}
});
