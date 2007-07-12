qx.Class.define("login.App",
{
	extend : qx.application.Gui,
	
	include: lib.dao.Auth,
	
	members:
	{
		main: function (e){
			this.base(arguments);
			
			qx.io.Alias.getInstance().add("resource", qx.core.Setting.get("login.resource"))
			
			qx.Class.createNamespace("global.mainframe", new qx.ui.layout.DockLayout);
			
			qx.Class.createNamespace("global.statusbar", new lib.ui.StatusBar);
			qx.Class.createNamespace("global.loginview", new login.LoginView);
			
			with(global.mainframe) {
				set({left: 0, top: 0, height: "100%", width: "100%"});
				addBottom(global.statusbar);
				addRight(global.loginview.center_on_grid());
			}
			
			qx.ui.core.ClientDocument.getInstance().add(global.mainframe);
		},
		
		close: function(e) { this.base(arguments); },
		terminate: function(e) { this.base(arguments); }
	},
	
	settings:
	{
		"login.resource": "../resource"
	}
});
