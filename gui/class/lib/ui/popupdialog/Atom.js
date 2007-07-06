qx.Class.define("lib.ui.popupdialog.Atom",
{
	extend: lib.ui.popupdialog.Base,
	
	construct: function (parent, message, icon) {
		this.base(arguments, parent, new qx.ui.basic.Atom(message, icon));
	}
});
