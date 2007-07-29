qx.Class.define("login.LoginButton",
{
	extend: qx.ui.basic.Atom,
	
	include: lib.dao.api.Auth,
	
	properties:
	{
		loading: { check: "Boolean", init: false, apply: "apply_loading" }
	},
	
	construct: function(user_field, password_field, admin_field) {
		this.base(arguments, "", this.icon_login);
		with(this) {
			setSpacing(4);
			setIconPosition("right");
			setHorizontalAlign("right");
		}
		
		this.addEventListener("click", function(e) {
			if ( this.getLoading() ){ return; }
			this.setLoading(true);
			
			this.login(user_field.getComputedValue(),
				password_field.getComputedValue(), admin_field.getChecked());
		});
	},
	
	members:
	{
		icon_login: "icon/32/actions/go-next.png",
		icon_loading: "resource/loading.gif",
		
		apply_loading: function(newValue, oldValue) {
			if (newValue) {
				this.setIcon(this.icon_loading);
			}
			else {
				this.setIcon(this.icon_login);
			}
		},
		
		login: function(user, password, admin) {
			var login_rq = null;
			if (admin) {
				login_rq = this.auth_login_admin(password);
			}
			else {
				login_rq = this.auth_login(user, password);
			}
			
			login_rq.addEventListener("fail", function(e) {
				this.setLoading(false);
				
				/*global.loginview.getPanel().add(
					new qx.ui.basic.Atom("Invalid Login",
						"icon/22/status/dialog-error.png"));*/
				new lib.ui.popupdialog.Atom(global.loginview.getPanel(), "Invalid Login", "icon/22/status/dialog-error.png");
			}, this);
			
			login_rq.addEventListener("ok", function(e) {
				var session_id = e.getData();
				if (admin) {
					lib.dao.Cookie.set_session_id("admin", session_id);
					lib.lang.Redirect.redirect_to("./admin.html");
				}
				else {
					lib.dao.Cookie.set_session_id("ide", session_id);
					lib.dao.Cookie.set_session_id("config", session_id);
					lib.lang.Redirect.redirect_to("./ide.html");
				}
			}, this);
		}
	}
});
