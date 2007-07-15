qx.Class.define("admin.AdminView",
{
	extend: qx.ui.pageview.buttonview.ButtonView,
	
	properties:
	{
		tabs: { check: "lib.lang.List", init: new lib.lang.List() },
		selected: { check: "lib.ui.PageViewTab" }
	},
	
	construct: function () {
		this.base(arguments);
		
		this.add_tab(new admin.tab.System);
		this.add_tab(new admin.tab.User);
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
