var widely = [];

qx.Class.define("config.App",
{
	extend : qx.application.Gui,
	
	include: lib.dao.Auth,
	
	properties:
	{
		frame: { check: "qx.ui.layout.DockLayout" }
	},
	
	members:
	{
		main: function (e){
			this.base(arguments);
			
			widely.statusbar = new lib.ui.StatusBar;
			widely.configview = new config.ConfigView;
			
			var frame = new qx.ui.layout.DockLayout()
			with(frame) {
				set({left: 0, top: 0, height: "100%", width: "100%"});
				addBottom(widely.statusbar);
				add(widely.configview);
			}
			
			qx.ui.core.ClientDocument.getInstance().add(frame);
			
			this.dao_login("test", "test");
		},
		
		close: function(e) { this.base(arguments); },
		terminate: function(e) { this.base(arguments); }
	},
	
	settings:
	{
		"config.resourceUri": "./resource"
	}
});
