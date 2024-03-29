/*
 * El tab con las preferencias del usuario
 * actualmente unicamente permite cambiar la clave del usuario
 *
 */
qx.Class.define("config.tab.UserPreferences",
{
	extend: lib.ui.PageViewTab,
	
	include: lib.dao.api.Auth,
	
	properties:
	{
		// El boton de guardar los cambios
		save: { check: "qx.ui.form.Button" },
		// La forma para cambiar la clave del usuario
		changepassword: { check: "lib.form.ChangePassword" }
	},
	
	construct: function () {
		this.base(arguments,
			"buttonview",
			"User Preferences",
			"icon/32/actions/identity.png");
		
		this.getButton().setChecked(true);
		
		this.setChangepassword(new lib.form.ChangePassword());
		
		this.setSave(new qx.ui.form.Button("Save", "icon/22/actions/document-save.png"));
		
		this.getSave().addEventListener("execute", function(e) {
			this.getChangepassword().change_password();
		}, this);
		
		var l = new qx.ui.layout.GridLayout();
		with(l) {
			set({left: 0, top: 0, height: "100%", width: "100%"});
			setColumnCount(3);
			setRowCount(3);
			
			setColumnWidth(0, "40%");
			setColumnWidth(1, "30%");
			setColumnWidth(2, "30%");
			
			setRowHeight(0, "40%");
			setRowHeight(1, "30%");
			setRowHeight(2, "30%");
			
			add(this.getChangepassword(), 0, 0);
			add(this.getSave(), 2, 2);
		}
		
		this.getPage().add(l);
	}
});
