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
