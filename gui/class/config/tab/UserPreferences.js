qx.Class.define("config.tab.UserPreferences",
{
	extend: lib.ui.PageViewTab,
	
	properties:
	{
		save: { check: "qx.ui.form.Button" },
		password1: { check: "lib.ui.AtomField" },
		password2: { check: "lib.ui.AtomField" }
	},
	
	construct: function () {
		this.base(arguments,
			"buttonview",
			"User Preferences",
			"icon/32/categories/preferences.png");
		
		this.getButton().setChecked(true);
		this.setSave(new qx.ui.form.Button("Save", "icon/22/actions/encrypt.png"));
		this.getSave().addEventListener("execute", function(e) {
			if (this.check_passwords()) {
				this.change_password(this.getPassword1().getField().getComputedValue());
			}
			else {
				new lib.ui.popupdialog.Atom(this.getPassword1(), "Password Mismatch",
					"icon/22/status/dialog-error.png");
			}
		}, this);
		
		this.setPassword1(new lib.ui.AtomField("Password", "icon/22/actions/encrypt.png", new qx.ui.form.PasswordField("")));
		
		this.setPassword2(new lib.ui.AtomField("Retype Password", "icon/22/actions/encrypt.png", new qx.ui.form.PasswordField("")));
		
		var l = new qx.ui.layout.GridLayout();
		with(l) {
			set({left: 0, top: 0, height: "100%", width: "100%"});
			setColumnCount(3);
			setRowCount(4);
			
			setColumnWidth(0, "40%");
			setColumnWidth(1, "40%");
			setColumnWidth(2, "20%");
			
			setRowHeight(0, "10%");
			setRowHeight(1, "10%");
			setRowHeight(2, "60%");
			setRowHeight(3, "20%");
			
			add(this.getPassword1(), 0, 0);
			add(this.getPassword2(), 0, 1);
			add(this.getSave(), 1, 3);
		}
		
		this.getPage().add(l);
	},
	
	members:
	{
		check_passwords: function() {
			if ( this.getPassword1().getField().getComputedValue() ==
				this.getPassword2().getField().getComputedValue() ) {
				
				return true;
			}
			
			return false;
		},
		
		change_password: function(new_password) {
			this.debug("password change");
		}
	}
});
