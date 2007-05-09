qx.Class.define("ui.versions.VersionsView",
{
	type: "singleton",
	
	extend: qx.ui.layout.VerticalBoxLayout,
	
	construct: function () {
		this.base(arguments);
		
		this.set({height: "100%", width: "100%"});
		
		this.setToolbar(new ui.versions.ToolBar());
		this.add(this.getToolbar());
		
		this.setVtable(new ui.versions.VTable());
		this.add(this.getVtable());
	},
	
	properties:
	{
		vtable: { check: "ui.versions.VTable" },
		toolbar: { check: "ui.versions.ToolBar" }
	}
});
