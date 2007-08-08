/*
 * La vista principal que permite a los usuarios ingresar al sistema
 *
 */
qx.Class.define("login.LoginView",
{
	extend: qx.ui.layout.CanvasLayout,
	
	properties:
	{
		panel: { check: "qx.ui.layout.VerticalBoxLayout" },
		// El nombre del usuario
		username: { check: "qx.ui.form.TextField" },
		usernamef: { check: "lib.ui.AtomField" },
		
		// La clave del usuario
		password: { check: "qx.ui.form.PasswordField" },
		passwordf: { check: "lib.ui.AtomField" },
		
		// Un checkbox que indica si es el admin quien va a ingresar
		admincheck: { check: "qx.ui.form.CheckBox" },
		
		// El boton de Login
		loginbutton: { check: "login.LoginButton" }
	},
	
	construct: function() {
		this.base(arguments);
		with(this) {
			setBorder("outset");
			set({ maxWidth: "auto", maxHeight: "auto" });
			set({minWidth: "auto", minHeight: "auto"});
			set({width: "auto", height: "auto"});
			setPadding(20);
		}
		
		this.setPanel(new qx.ui.layout.VerticalBoxLayout);
		with (this.getPanel()) {
			set({ left: 0, top: 0, width: "auto", height: "auto" });
			setSpacing(4);
		}
		
		this.setUsername(new qx.ui.form.TextField(""));
		var u = this.getUsername();
		this.setUsernamef(new lib.ui.AtomField("User", "icon/22/apps/system-users.png", u));
		
		this.setPassword(new qx.ui.form.PasswordField(""));
		var p = this.getPassword();
		this.setPasswordf(new lib.ui.AtomField("Password", "icon/22/actions/encrypt.png",p));
		
		var spacer = new qx.ui.basic.VerticalSpacer()
		spacer.setHeight(5);
		
		this.setAdmincheck(new qx.ui.form.CheckBox("Admin", "admin", "admin", false));
		var a = this.getAdmincheck();
		a.addEventListener("changeChecked", function(e) {
			this.getUsernamef().setEnabled(!e.getValue());
		}, this);
		
		this.setLoginbutton(new login.LoginButton(u, p, a));
		
		with(this.getPanel()) {
			add(this.getUsernamef());
			add(this.getPasswordf());
			add(spacer);
			add(a);
			add(this.getLoginbutton());
		}
		
		this.add(this.getPanel());
	},
	
	members:
	{
		/*
		 * Crea una grilla y ubica esta vista centrada dentro de
		 * ella
		 *
		 */
		
		center_on_grid: function(){
			var grid = new qx.ui.layout.GridLayout();
			with(grid) {
				set({width: "40%"});
				
				setColumnCount(3);
				setColumnWidth(0, "20%");
				setColumnWidth(1, "60%");
				setColumnWidth(2, "20%");
				
				setRowCount(3);
				setRowHeight(0, "20%");
				setRowHeight(1, "60%");
				setRowHeight(2, "20%");
				
				add(this, 1, 1);
			}
			
			return grid;
		}
	},
	
	settings : {"login.resourceUri" : "./resource" }
});
