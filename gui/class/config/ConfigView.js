/*
 * La vista principal para la administracion
 * de la configuracion del usuario
 *
 */
qx.Class.define("config.ConfigView",
{
	extend: qx.ui.pageview.buttonview.ButtonView,
	
	properties:
	{
		tabs: { check: "lib.lang.List", init: new lib.lang.List() },
		selected: { check: "lib.ui.PageViewTab" }
	},
	
	construct: function () {
		this.base(arguments);
		
		this.add_tab(new config.tab.UserPreferences);
		this.add_tab(new config.tab.Repo);
		this.add_tab(new config.tab.WC);
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
