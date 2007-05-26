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
			
			var rq = new core.WRequest(
				"auth", "login",
				{
					user_id: _user,
					password: _password
				},
				function(data){
					this.setID(data);
					core.Obj.session = this;
					core.Obj.statusbar.ok("Logged in");
					if (callback) { callback.call(_this); }
				},
				this
			);
			core.Obj.statusbar.process("Logging user: "+this.getUser());
			rq.send();
		},
		
		dao_set_wc: function(_wc_id, callback, _this){
			var rq = new core.WRequest(
				"auth", "set_wc",
				{
					session_id: core.Obj.session.getID(),
					wc_id: _wc_id
				},
				function(data){
					core.Obj.statusbar.ok("WC: set");
					if (callback) { callback.call(_this); }
				},
				this
			);
			core.Obj.statusbar.process("Setting WC: "+_wc_id);
			rq.send();
		}
	}
});
