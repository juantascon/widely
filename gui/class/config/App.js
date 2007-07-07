qx.Class.define("config.App",
{
	extend : qx.application.Gui,
	
	include: lib.dao.Auth,
	
	members:
	{
		main: function (e){
			this.base(arguments);
			
			qx.Class.createNamespace("global.mainframe", new qx.ui.layout.DockLayout);
			
			qx.Class.createNamespace("global.statusbar", new lib.ui.StatusBar);
			qx.Class.createNamespace("global.configview", new config.ConfigView);
			
			qx.Class.createNamespace("global.session.id", -1);
			qx.Class.createNamespace("global.session.user", "test");
			
			with(global.mainframe) {
				set({left: 0, top: 0, height: "100%", width: "100%"});
				addBottom(global.statusbar);
				add(global.configview);
			}
			
			qx.ui.core.ClientDocument.getInstance().add(global.mainframe);
			
			var login_rq = this.auth_login(global.session.user, global.session.user);
			login_rq.addEventListener("ok", function(e){
				global.session.id = e.getData();
			}, this);
		},
		
		close: function(e) { this.base(arguments); },
		terminate: function(e) { this.base(arguments); }
	}
});
