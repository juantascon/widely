qx.Class.define("admin.App",
{
	extend : qx.application.Gui,
	
	include: lib.dao.Auth,
	
	members:
	{
		main: function (e){
			this.base(arguments);
			
			qx.Class.createNamespace("global.mainframe", new qx.ui.layout.DockLayout);
			
			qx.Class.createNamespace("global.statusbar", new lib.ui.StatusBar);
			qx.Class.createNamespace("global.adminview", new admin.AdminView);
			
			qx.Class.createNamespace("global.session.id", -1);
			
			with(global.mainframe) {
				set({left: 0, top: 0, height: "100%", width: "100%"});
				addBottom(global.statusbar);
				add(global.adminview);
			}
			
			qx.ui.core.ClientDocument.getInstance().add(global.mainframe);
			
			var login_rq = this.auth_login_admin("admin");
			login_rq.addEventListener("ok", function(e){
				global.session.id = e.getData();
			}, this);
		},
		
		close: function(e) { this.base(arguments); },
		terminate: function(e) { this.base(arguments); }
	}
});
