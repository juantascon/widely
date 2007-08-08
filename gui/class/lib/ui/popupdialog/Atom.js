/*
 * Dialogo en forma de popup con un texto informativo
 * y un icono
 *
 */
qx.Class.define("lib.ui.popupdialog.Atom",
{
	extend: lib.ui.popupdialog.Base,
	
	/*
	 * position_parent: el padre para la posicion relavita del dialogo
	 * message: el texto que se va a mostrar en el dialogo
	 * icon: el icono para mostrar en el dialogo
	 *
	 */
	construct: function (position_parent, message, icon) {
		this.base(arguments, position_parent, new qx.ui.basic.Atom(message, icon));
	}
});
