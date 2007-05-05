qx.Class.define("ui.StatusBar",
{
	type: "singleton",
	
	extend: qx.ui.layout.CanvasLayout,
	
	construct: function () {
		qx.ui.layout.CanvasLayout.call(this);
		
		this.setHeight("auto");
		
		this.setLabel(new qx.ui.basic.Label("hola", ""));
		this.getLabel().setMinHeight("auto");
		this.add(this.getLabel());
	},
	
	properties:
	{
		label: { check: "qx.ui.basic.Label" }
	}
});
