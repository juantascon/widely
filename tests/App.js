qx.Class.define("test.App",
{
	extend : qx.application.Gui,
	
	include: lib.dao.Auth,
	
	members:
	{
		main: function(e) {
			this.base(arguments);
			
			qx.Class.createNamespace("cons.WC", -1);
			
			qx.Class.createNamespace("global.mainframe", new qx.ui.layout.DockLayout);
			qx.Class.createNamespace("global.statusbar", new lib.ui.StatusBar);
			qx.Class.createNamespace("global.session.id", -1);
			qx.Class.createNamespace("global.session.user", "test");
			
			var login_rq = this.auth_login(global.session.user, global.session.user);
			login_rq.addEventListener("ok", function(e){
				global.session.id = e.getData();
				var set_wc_rq = this.auth_set_wc("project1-wc1");
				set_wc_rq.addEventListener("ok", function(e){
					this.test();
				},  this);
			}, this);
		},
		
		test: function() {
			var b1 = new qx.ui.form.Button("Boton");
			with(b1) {
				setTop(48);
				setLeft(20);
				setBackgroundColor("#BDD2EF");
				setWidth(100);
				setHeight(100);
				setBorder("outset");
				setHorizontalAlign("center");
			}
			
			b1.addEventListener("click", function(e) {
				var form = new lib.form.NewRepo();
				form.create_dialog(global.mainframe, "New Repo");
			});
			
			//global.mainframe.add(b1);
			qx.ui.core.ClientDocument.getInstance().add(b1);
			
		},
		
		close: function(e) { this.base(arguments); },
		
		terminate: function(e) { this.base(arguments); }
	}
});
