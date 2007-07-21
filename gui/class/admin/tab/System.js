qx.Class.define("admin.tab.System",
{
	extend: lib.ui.PageViewTab,
	
	construct: function () {
		this.base(arguments,
			"buttonview",
			"System",
			"icon/32/categories/preferences-system.png");
		
		this.getButton().setChecked(true);
		this.getPage().add(new qx.ui.form.TextField(""));
	}
});