/*
 * Tab que encapsula el boton y la pagina para los pageviews
 * de QooxDoo
 *
 */
qx.Class.define("lib.ui.PageViewTab",
{
	type: "abstract",
	
	extend: qx.core.Object,
	
	properties:
	{
		viewtype: { check: ["buttonview", "tabview"] },
		
		button: { check: "qx.ui.pageview.AbstractButton" },
		page: { check: "qx.ui.pageview.AbstractPage" }
	},
	
	/*
	 * viewtype: el tipo de pageview <"buttonview"|"tabview">
	 * title: el titulo del boton
	 * icon: el icono del boton
	 *
	 */
	construct: function (viewtype, title, icon) {
		this.base(arguments);
		
		this.setViewtype(viewtype);
		
		var construct_button = null;
		var construct_page = null;
		
		switch (this.getViewtype()) {
			case "buttonview":
				construct_button = qx.ui.pageview.buttonview.Button;
				construct_page = qx.ui.pageview.buttonview.Page;
				break;
			case "tabview":
				construct_button = qx.ui.pageview.tabview.Button;
				construct_page = qx.ui.pageview.tabview.Page;
				break;
		}
		
		this.setButton(new construct_button(title, icon));
		this.setPage(new construct_page(this.getButton()));
	}
});
