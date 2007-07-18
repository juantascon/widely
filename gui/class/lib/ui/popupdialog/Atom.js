qx.Class.define("lib.ui.popupdialog.Atom",
{
	extend: lib.ui.popupdialog.Base,
	
	construct: function (position_parent, message, icon) {
		this.base(arguments, position_parent, new qx.ui.basic.Atom(message, icon));
	}
});
