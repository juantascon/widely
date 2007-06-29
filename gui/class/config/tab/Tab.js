qx.Class.define("config.tab.Tab",
{
	type: "abstract",
	
	extend: qx.core.Object,
	
	construct: function (title, icon) {
		this.base(arguments);
		
		this.setButton(new qx.ui.pageview.buttonview.Button(title, icon));
		this.setPage(new qx.ui.pageview.buttonview.Page(this.getButton()));
	},
	
	properties:
	{
		button: { check: "qx.ui.pageview.buttonview.Button" },
		page: { check: "qx.ui.pageview.buttonview.Page" }
	}
});
