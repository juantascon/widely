qx.Class.define("lib.form.NewUser",
{
	extend: qx.ui.groupbox.GroupBox,
	
	include: [ lib.dao.api.User, lib.form.Helper ],
	
	properties:
	{
		grid: { check: "qx.ui.layout.GridLayout" },
		name_i: { check: "qx.ui.form.TextField" },
		password_i: { check: "qx.ui.form.PasswordField" }
	},
	
	construct: function () {
		this.base(arguments, "New User Info");
		this.set({left: 0, top: 0, height: "auto", width: "auto"});
		
		this.setName_i(new qx.ui.form.TextField(""));
		this.setPassword_i(new qx.ui.form.PasswordField(""));
		
		this.setGrid(this.create_grid(
			[ "Name", "Password" ],
			[ this.getName_i(), this.getPassword_i() ],
			80, 200
		));
		
		this.add(this.getGrid());
	},
	
	members:
	{
		run: function(pmodal, callback, _this){
			var d = this.create_dialog(pmodal, "New User");
			
			d.addEventListener("ok", function(e) {
				
				var create_rq = this.user_create(
					this.getName_i().getComputedValue(),
					this.getPassword_i().getComputedValue() );
				
				create_rq.addEventListener("ok", callback, _this);
				
			}, this);
		}
	}
});
