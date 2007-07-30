qx.Class.define("login.App",
{
	extend: lib.WApp,
	
	members:
	{
		main: function(e) {
			this.base(arguments);
			
			this.init_wapp("login", "user");
			this.init_mainframe();
			this.init();
		},
		
		init: function() {
			qx.io.Alias.getInstance().add("resource", qx.core.Setting.get("login.resources"));
			qx.Class.createNamespace("global.loginview", new login.LoginView);
			global.mainframe.addRight(global.loginview.center_on_grid());
		}
	},
	
	settings:
	{
		"login.resources": "../resource"
	}
});
