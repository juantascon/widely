qx.Class.define("test.App",
{
	extend : qx.application.Gui,
	
	include: lib.dao.Auth,
	
	members:
	{
		main: function(e) {
			this.base(arguments);
			
			qx.Class.createNamespace("cons.WC", -1);
			
			qx.Class.createNamespace("global.statusbar", new lib.ui.StatusBar);
			qx.Class.createNamespace("global.session.id", -1);
			qx.Class.createNamespace("global.session.user", "test");
			
			var login_rq = this.dao_login(global.session.user, global.session.user);
			login_rq.addEventListener("ok", function(e){
				global.session.id = e.getData();
				var set_wc_rq = this.dao_set_wc("project1-wc1");
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
				d = new lib.ui.popupdialog.Input(b1, "archivo");
				d.addEventListener("ok", function(e) {
					this.debug(d.getContent().getComputedValue());
				}, this);
			});
			
			qx.ui.core.ClientDocument.getInstance().add(b1);
			
		},
		
		close: function(e) { this.base(arguments); },
		
		terminate: function(e) { this.base(arguments); }
	}
});
