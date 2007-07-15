qx.Class.define("admin.App",
{
	extend: lib.WApp,
	
	members:
	{
		main: function (e) {
			this.base(arguments, "admin");
			
			this.init_session("admin", function() {
			/*var rq = this.auth_login_admin("admin");
			rq.addEventListener("ok", function(e) {
				global.session.id = e.getData();*/
				
				qx.Class.createNamespace("global.adminview", new admin.AdminView);
				global.mainframe.add(global.adminview);
			}, this);
		}
	}
});
