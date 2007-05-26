qx.Class.define("core.Login",
{
	extend: qx.core.Object,
	
	include: dao.Session,
	
	construct: function () {
		this.base(arguments);
	},
	
	members:
	{
		start: function() {
			var login_d = new ui.component.LoginDialog("Login");
			
			login_d.addEventListener("ok", function(e) {
				var user = login_d.get_user_text();
				var password = login_d.get_password_text();
				
				this.dao_login(user, password, function(e) {
					this.dao_set_wc(
						"project-wc1",
						core.Obj.selector.getVmtable().dao_load,
						core.Obj.selector.getVmtable()
					);
				}, this);
			}, this);
		}
	}
});
