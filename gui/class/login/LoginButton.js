qx.Class.define("login.LoginButton",
{
	extend: qx.ui.basic.Atom,
	
	include: lib.dao.api.Auth,
	
	properties:
	{
		loading: { check: "Boolean", init: false, apply: "apply_loading" }
	},
	
	construct: function(user_field, password_field) {
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
				password_field.getComputedValue());
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
		
		login: function(user, password) {
			var login_rq = this.auth_login(user, password);
			
			login_rq.addEventListener("fail", function(e) {
				this.setLoading(false);
				
				global.loginview.getPanel().add(
					new qx.ui.basic.Atom("Invalid Login",
						"icon/22/status/dialog-error.png"));
			}, this);
			
			login_rq.addEventListener("ok", function(e) {
				window.location = "./ide.html";
			}, this);
		}
	}
});
