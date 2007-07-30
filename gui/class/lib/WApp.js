qx.Class.define("lib.WApp",
{
	type: "abstract",
	
	extend: qx.application.Gui,
	
	include: lib.dao.api.Auth,
	
	members:
	{
		init_wapp: function(name, type) {
			qx.Class.createNamespace("global.app.name", name);
			qx.Class.createNamespace("global.app.instance", this);
			qx.Class.createNamespace("global.app.type", type);
		},
		
		init_mainframe: function() {
			qx.Class.createNamespace("global.mainframe", new qx.ui.layout.DockLayout);
			qx.Class.createNamespace("global.statusbar", new lib.ui.StatusBar);
			
			with(global.mainframe) {
				set({left: 0, top: 0, height: "100%", width: "100%"});
				addBottom(global.statusbar);
			}
			
			qx.ui.core.ClientDocument.getInstance().add(global.mainframe);
		},
		
		init_session: function() {
			qx.Class.createNamespace("global.session.id", -1);
			var session_id = lib.dao.Cookie.get_session_id();
			
			var rq = this.auth_session_type(session_id);
			rq.addEventListener("ok", function(e) {
				var type = e.getData();
				if ( type == global.app.type ) {
					global.session.id = session_id;
					this.init();
				}
				else {
					lib.lang.Redirect.fallback_redirect();
				}
			}, this);
			
			rq.addEventListener("fail", function(e) {
				lib.lang.Redirect.fallback_redirect();
			});
		},
		
		quit: function() {
			this.auth_logout();
			lib.dao.Cookie.set_session_id(global.app.name, -1);
			lib.lang.Redirect.fallback_redirect();
		},
		
		close: function(e) { this.base(arguments); },
		terminate: function(e) { this.base(arguments); }
	}
});
