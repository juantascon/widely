qx.Class.define("config.App",
{
	extend : qx.application.Gui,
	
	include: lib.dao.Auth,
	
	properties:
	{
		frame: { check: "qx.ui.layout.DockLayout" }
	},
	
	members:
	{
		main: function (e){
			this.base(arguments);
			
			qx.Class.createNamespace("global.statusbar", new lib.ui.StatusBar);
			qx.Class.createNamespace("global.configview", new config.ConfigView);
			
			qx.Class.createNamespace("global.session.id", -1);
			qx.Class.createNamespace("global.session.user", "test");
			
			var frame = new qx.ui.layout.DockLayout()
			with(frame) {
				set({left: 0, top: 0, height: "100%", width: "100%"});
				addBottom(global.statusbar);
				add(global.configview);
			}
			
			qx.ui.core.ClientDocument.getInstance().add(frame);
			
			var login_rq = this.dao_login(global.session.user, global.session.user);
			login_rq.addEventListener("ok", function(e){
				global.session.id = e.getData();
			}, this);
		},
		
		close: function(e) { this.base(arguments); },
		terminate: function(e) { this.base(arguments); }
	}
});
