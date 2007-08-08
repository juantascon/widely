/*
 * Crea mensajes de errores de informacion para el usuario
 *
 */

qx.Class.define("lib.ui.Msg",
{
	type: "static",
	
	statics:
	{
		/*
		 * Mensaje de error
		 *
		 * position_parent: el padre para la posicion relativa del dialogo
		 * msg: el mensaje a mostrar
		 *
		 */
		error: function(position_parent, msg) {
			return new lib.ui.popupdialog.Atom(position_parent,
				msg, "icon/22/status/dialog-error.png");
		},
		
		/*
		 * Mensaje de warining
		 *
		 * position_parent: el padre para la posicion relativa del dialogo
		 * msg: el mensaje a mostrar
		 *
		 */
		warn: function(position_parent, msg) {
			return new lib.ui.popupdialog.Atom(position_parent,
				msg, "icon/22/status/dialog-warning.png");
		},
		
		/*
		 * Mensaje de informativo
		 *
		 * position_parent: el padre para la posicion relativa del dialogo
		 * msg: el mensaje a mostrar
		 *
		 */
		info: function(position_parent, msg) {
			return new lib.ui.popupdialog.Atom(position_parent,
				msg, "icon/22/status/dialog-information.png");
		}
	}
});
