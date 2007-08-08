/*
 * Dialogo en forma de popup con un campo de texto
 * para entrada de datos
 *
 */
qx.Class.define("lib.ui.popupdialog.Input",
{
	extend: lib.ui.popupdialog.Base,
	
	properties:
	{
		// El campo de texto
		field: { check: "qx.ui.form.TextField" }
	},
	
	/*
	 * position_parent: el padre para la posicion relativa del dialogo
	 * init_label: el contenido inicial del campo de texto
	 */
	construct: function (position_parent, init_label) {
		if (!init_label){ init_label = ""; }
		
		this.setField(new qx.ui.form.TextField(init_label));
		with (this.getField()) {
			setEdge(0, 0, 0, 0);
		}
		
		this.base(arguments, position_parent, this.getField());
	},
	
	members:
	{
		// Obtiene el contenido del campo de texto
		get_text: function() {
			return this.getField().getComputedValue();
		}
	}
});
