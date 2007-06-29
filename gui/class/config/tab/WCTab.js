qx.Class.define("config.tab.WCTab",
{
	extend: config.tab.Tab,
	
	construct: function () {
		this.base(arguments, "Working Copies", "icon/32/places/document-folder.png");
		this.getPage().add(new qx.ui.form.TextField(""));
		
	}
});
