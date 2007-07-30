qx.Class.define("admin.App",
{
	extend: lib.WApp,
	
	members:
	{
		main: function(e) {
			this.base(arguments);
			
			this.init_wapp("admin", "admin");
			this.init_mainframe();
			this.init_session();
		},
		
		init: function() {
			qx.Class.createNamespace("global.adminview", new admin.AdminView);
			global.mainframe.add(global.adminview);
		}
	}
});
