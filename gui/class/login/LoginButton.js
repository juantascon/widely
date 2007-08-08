/*
 * El boton que realiza el proceso de ingresar al sistema
 *
 */

qx.Class.define("login.LoginButton",
{
	extend: qx.ui.basic.Atom,
	
	include: lib.dao.api.Auth,
	
	properties:
	{
		// Flag que indica si se esta intentando el ingreso
		loading: { check: "Boolean", init: false, apply: "apply_loading" }
	},
	
	/*
	 * user_field: el campo con el nombre de usuario
	 * password_field: el campo con la clave del usuario
	 * admin_field: el campo que indica si se debe ingresar en modo administrador
	 *
	 */
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
		// El icono en estado normal
		icon_login: "icon/32/actions/go-next.png",
		
		// El icono para el estado ingresando
		icon_loading: "resource/loading.gif",
		
		/*
		 * Callback para el cambio del atributo loading, se encarga
		 * de cambiar el icono cuando hay un cambio de estado
		 *
		 */
		apply_loading: function(newValue, oldValue) {
			if (newValue) {
				this.setIcon(this.icon_loading);
			}
			else {
				this.setIcon(this.icon_login);
			}
		},
		
		/*
		 * El proceso de ingreso, a partir de los datos deside que tipo de ingreso
		 * debe hacer y procede a redireccionar hacia la pagina indicada
		 *
		 * user: el nombre de usuario
		 * password: la clave del usuario
		 * admin: el flag que indica si se debe proceder con un ingreso tipo administrador o
		 * tipo usuario
		 *
		 */
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
				lib.ui.Msg.error(global.loginview.getPanel(), "Invalid Login");
			}, this);
			
			login_rq.addEventListener("ok", function(e) {
				var session_id = e.getData();
				/*
				 * dependiendo del tipo de ingreso debe almancenar la cookie
				 * adecuada
				 *
				 */
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
