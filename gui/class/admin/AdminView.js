/*
 * La vista principal para la administracion
 * del servidor y los usuarios
 *
 */
qx.Class.define("admin.AdminView",
{
	extend: qx.ui.pageview.buttonview.ButtonView,
	
	properties:
	{
		// La lista de los tabs
		tabs: { check: "lib.lang.List", init: new lib.lang.List() },
		// El tab seleccionado
		selected: { check: "lib.ui.PageViewTab" }
	},
	
	construct: function () {
		this.base(arguments);
		
		this.add_tab(new admin.tab.System);
		this.add_tab(new admin.tab.User);
		
		var logout_button = new qx.ui.pageview.buttonview.Button("Logout", "icon/32/actions/application-exit.png");
		logout_button.addEventListener("click", function(e){
			var confirm = lib.ui.Msg.warn(global.mainframe, "Do you really want to logout?");
			confirm.addEventListener("ok", function(e) {
				// termina la aplicacion
				global.app.instance.quit();
			});
		});
		this.getBar().add(new qx.ui.basic.HorizontalSpacer());
		this.getBar().add(logout_button);
	},
	
	members:
	{
		/*
		 * Adiciona un tab a la vista
		 *
		 * tab: el tab a adicionar
		 *
		 */
		add_tab: function(tab){
			this.getTabs().add(tab);
			this.getBar().add(tab.getButton());
			this.getPane().add(tab.getPage());
			
			return tab;
		}
	}
});
