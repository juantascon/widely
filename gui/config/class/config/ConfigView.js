qx.Class.define("config.ConfigView",
{
	type: "singleton",
	
	extend: qx.ui.pageview.buttonview.ButtonView,
	
	construct: function () {
		this.base(arguments);
		
		this.add_tab(new ui.config.UserPreferencesTab);
		this.add_tab(new ui.config.RepoTab);
		this.add_tab(new ui.config.WCTab);
	},
	
	members:
	{
		add_tab: function(config_tab){
			this.getBar().add(config_tab.getButton());
			this.getPane().add(config_tab.getPage());
		}
	}
});
