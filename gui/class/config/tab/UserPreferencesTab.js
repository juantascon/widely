qx.Class.define("config.tab.UserPreferencesTab",
{
	extend: config.tab.Tab,
	
	construct: function () {
		this.base(arguments, "User Preferences", "icon/32/categories/preferences.png");
		this.getButton().setChecked(true);
		this.getPage().add(new qx.ui.form.TextField(""));
	}
});
