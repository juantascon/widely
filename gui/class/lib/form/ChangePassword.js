/*
 * Esta Forma permite cambiar una contraseña de usuario
 *
 */
qx.Class.define("lib.form.ChangePassword",
{
	extend: qx.ui.layout.VerticalBoxLayout,
	
	include: lib.dao.api.Auth,
	
	properties:
	{
		// La clave antigua
		passwordold: { check: "lib.ui.AtomField" },
		// La clave nueva
		passwordnew1: { check: "lib.ui.AtomField" },
		// Repetir la clave nueva
		passwordnew2: { check: "lib.ui.AtomField" }
	},
	
	construct: function () {
		this.base(arguments);
		
		this.setPasswordold(new lib.ui.AtomField("Current Password",
			"icon/22/status/dialog-password.png", new qx.ui.form.PasswordField("")));
		
		this.setPasswordnew1(new lib.ui.AtomField("New Password",
			"icon/22/status/dialog-password.png", new qx.ui.form.PasswordField("")));
		
		this.setPasswordnew2(new lib.ui.AtomField("Retype New Password",
			"icon/22/status/dialog-password.png", new qx.ui.form.PasswordField("")));
		
		with(this) {
			set({left: 0, top: 0, height: "100%", width: "100%"});
			add(this.getPasswordold());
			add(this.getPasswordnew1());
			add(this.getPasswordnew2());
		}
	},
	
	members:
	{
		// Retorna el valor ingresado como clave antigua
		pold: function() {
			return this.getPasswordold().getField().getComputedValue();
		},
		
		// Retorna el valor ingresado como clave nueva
		pnew1: function() {
			return this.getPasswordnew1().getField().getComputedValue();
		},
		
		// Retorna el valor ingresado como repeticion de la clave nueva
		pnew2: function() {
			return this.getPasswordnew2().getField().getComputedValue();
		},
		
		/*
		 * Hace las siguientes comprobaciones en las claves
		 * 1. que la clave nueva sea igual a su repeticion
		 * 2. que el tamaño de la clave nueva sea mayor a 3
		 *
		 */
		check_passwords: function() {
			if ( this.pnew1() == this.pnew2() ) {
				if (this.pnew1().length > 3) {
					return true;
				}
				
				lib.ui.Msg.error(this.getPasswordnew1(), "New Password too short");
				return false;
			}
			
			lib.ui.Msg.error(this.getPasswordnew1(), "New Password Mismatch");
			return false;
		},
		
		/*
		 * Envia la peticion al servidor para cambiar la clave
		 *
		 */
		change_password: function() {
			if (this.check_passwords()) {
				var ch_rq = this.auth_change_password(this.pold(), this.pnew1());
				
				ch_rq.addEventListener("fail", function(e) {
					lib.ui.Msg.error(this.getPasswordnew1(), e.getData());
				}, this);
				
				ch_rq.addEventListener("ok", function(e) {
					lib.ui.Msg.info(this.getPasswordnew1(), "Password updated");
				}, this);
			}
		}
	}
});
