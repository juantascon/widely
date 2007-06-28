qx.Class.define("lib.ui.LoginDialog",
{
	extend: lib.ui.Dialog,
	
	construct: function (title, user_field, password_field) {
		if (!user_field){ user_field = new qx.ui.form.TextField(""); }
		if (!password_field){ password_field = new qx.ui.form.PasswordField(""); }
		
		this.setUser(user_field);
		this.setPassword(password_field);
		
		var l_layout = new qx.ui.layout.VerticalBoxLayout();
		l_layout.set({ height: "auto", width: "auto" });
		
		var i_layout = new qx.ui.layout.VerticalBoxLayout();
		i_layout.set({ height: "auto", width: "auto" });
		
		var main_layout = new qx.ui.layout.HorizontalBoxLayout();
		main_layout.setEdge(0,0,0,0);
		main_layout.set({ height: "auto", width: "auto" });
		
		
		l_layout.add(
			new qx.ui.basic.Atom("User:"),
			new qx.ui.basic.Atom("<br/>"),
			new qx.ui.basic.Atom("Password:")
		);
		
		i_layout.add(this.getUser(), this.getPassword());
		
		main_layout.add(l_layout, i_layout);
		
		this.base(arguments, title, "", main_layout);
	},
	
	properties:
	{
		user: { check: "qx.ui.form.TextField" },
		password: { check: "qx.ui.form.PasswordField" }
	},
	
	members:
	{
		get_user_text: function() {
			return this.getUser().getComputedValue();
		},
		
		get_password_text: function() {
			return this.getPassword().getComputedValue();
		}
	}
});
