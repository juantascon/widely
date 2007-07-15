qx.Class.define("admin.App",
{
	extend: lib.WApp,
	
	members:
	{
		main: function (e) {
			this.base(arguments, "admin");
			
			this.init_session("admin", function() {
				qx.Class.createNamespace("global.adminview", new admin.AdminView);
				global.mainframe.add(global.adminview);
			}, this);
		}
	}
});
