qx.Class.define("config.ConfigView",
{
	extend: qx.ui.pageview.buttonview.ButtonView,
	
	construct: function () {
		this.base(arguments);
		
		this.add_tab(new config.tab.UserPreferencesTab);
		this.add_tab(new config.tab.RepoTab);
		this.add_tab(new config.tab.WCTab);
	},
	
	members:
	{
		add_tab: function(config_tab){
			this.getBar().add(config_tab.getButton());
			this.getPane().add(config_tab.getPage());
		}
	}
});
