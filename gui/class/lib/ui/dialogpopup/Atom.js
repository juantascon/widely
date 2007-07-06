qx.Class.define("lib.ui.dialogpopup.Atom",
{
	extend: lib.ui.dialogpopup.Base,
	
	construct: function (parent, message, icon) {
		this.base(arguments, parent, new qx.ui.basic.Atom(message, icon));
	}
	
});
