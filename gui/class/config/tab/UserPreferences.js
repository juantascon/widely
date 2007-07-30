qx.Class.define("config.tab.UserPreferences",
{
	extend: lib.ui.PageViewTab,
	
	include: lib.dao.api.Auth,
	
	properties:
	{
		save: { check: "qx.ui.form.Button" },
		password: { check: "lib.ui.AtomField" },
		passwordnew1: { check: "lib.ui.AtomField" },
		passwordnew2: { check: "lib.ui.AtomField" }
	},
	
	construct: function () {
		this.base(arguments,
			"buttonview",
			"User Preferences",
			"icon/32/actions/identity.png");
		
		this.getButton().setChecked(true);
		this.setSave(new qx.ui.form.Button("Save", "icon/22/actions/document-save.png"));
		this.getSave().addEventListener("execute", function(e) {
			if (this.check_passwords()) {
				var ch_rq = this.auth_change_password(this.p(), this.pn1());
				ch_rq.addEventListener("fail", function(e) {
					new lib.ui.popupdialog.Atom(this.getPasswordnew1(),
						e.getData(),
						"icon/22/status/dialog-error.png");
				}, this);
			}
		}, this);
		
		this.setPassword(new lib.ui.AtomField("Current Password", "icon/22/status/dialog-password.png", new qx.ui.form.PasswordField("")));
		
		this.setPasswordnew1(new lib.ui.AtomField("New Password", "icon/22/status/dialog-password.png", new qx.ui.form.PasswordField("")));
		
		this.setPasswordnew2(new lib.ui.AtomField("Retype New Password", "icon/22/status/dialog-password.png", new qx.ui.form.PasswordField("")));
		
		var l = new qx.ui.layout.GridLayout();
		with(l) {
			set({left: 0, top: 0, height: "100%", width: "100%"});
			setColumnCount(3);
			setRowCount(5);
			
			setColumnWidth(0, "40%");
			setColumnWidth(1, "20%");
			setColumnWidth(2, "40%");
			
			setRowHeight(0, "10%");
			setRowHeight(1, "10%");
			setRowHeight(2, "10%");
			setRowHeight(3, "50%");
			setRowHeight(4, "20%");
			
			add(this.getPassword(), 0, 0);
			add(this.getPasswordnew1(), 0, 1);
			add(this.getPasswordnew2(), 0, 2);
			add(this.getSave(), 2, 4);
		}
		
		this.getPage().add(l);
	},
	
	members:
	{
		p: function() {
			return this.getPassword().getField().getComputedValue();
		},
		
		pn1: function() {
			return this.getPasswordnew1().getField().getComputedValue();
		},
		
		pn2: function() {
			return this.getPasswordnew2().getField().getComputedValue();
		},
		
		check_passwords: function() {
			if ( this.pn1() == this.pn2() ) {
				if (this.pn1().length > 3) {
					return true;
				}
				
				new lib.ui.popupdialog.Atom(this.getPasswordnew1(),
					"New Password too short",
					"icon/22/status/dialog-error.png");
				
				return false;
			}
			
			new lib.ui.popupdialog.Atom(this.getPasswordnew1(),
				"New Password Mismatch",
				"icon/22/status/dialog-error.png");
			
			return false;
		},
		
		change_password: function(new_password) {
			
		}
	}
});
