qx.Class.define("config.tab.UserPreferencesTab",
{
	extend: lib.ui.PageViewTab,
	
	construct: function () {
		this.base(arguments,
			"buttonview",
			"User Preferences",
			"icon/32/categories/preferences.png");
		
		this.getButton().setChecked(true);
		this.getPage().add(new qx.ui.form.TextField(""));
	}
});
