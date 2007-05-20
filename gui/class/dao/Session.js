qx.Mixin.define("dao.Session",
{
	properties:
	{
		user: { check: "String", init: "" },
		ID: { check: "String", init: ""}
	},
	
	members:
	{
		dao_login: function(_user, _password, callback, _this){
			this.setUser(_user);
			
			var rq = new main.WRequest(
				"auth", "login",
				{
					user_id: _user,
					password: _password
				},
				function(data){
					this.setID(data);
					main.Obj.session = this;
					main.Obj.statusbar.ok("Logged in");
					if (callback) { callback.call(_this); }
				},
				this
			);
			main.Obj.statusbar.process("Logging user: "+this.getUser());
			rq.send();
		},
		
		dao_set_wc: function(_wc_id, callback, _this){
			var rq = new main.WRequest(
				"auth", "set_wc",
				{
					session_id: main.Obj.session.getID(),
					wc_id: _wc_id
				},
				function(data){
					main.Obj.statusbar.ok("WC: set");
					if (callback) { callback.call(_this); }
				},
				this
			);
			main.Obj.statusbar.process("Setting WC: "+_wc_id);
			rq.send();
		}
	}
});
