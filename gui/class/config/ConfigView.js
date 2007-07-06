qx.Class.define("config.ConfigView",
{
	extend: qx.ui.pageview.buttonview.ButtonView,
	
	properties:
	{
		tabs: { check: "lib.lang.List", init: new lib.lang.List() },
		selected: { check: "config.tab.Tab" }
	},
	
	construct: function () {
		this.base(arguments);
		
		this.add_tab(new config.tab.UserPreferencesTab);
		this.add_tab(new config.tab.RepoTab);
		this.add_tab(new config.tab.WCTab);
	},
	
	members:
	{
		add_tab: function(tab){
			this.getTabs().add(tab);
			this.getBar().add(tab.getButton());
			this.getPane().add(tab.getPage());
			
			return tab;
		}
	}
});
