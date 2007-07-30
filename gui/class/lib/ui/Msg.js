qx.Class.define("lib.ui.Msg",
{
	type: "static",
	
	statics:
	{
		error: function(position_parent, msg) {
			return new lib.ui.popupdialog.Atom(position_parent,
				msg, "icon/22/status/dialog-error.png");
		},
		
		warn: function(position_parent, msg) {
			return new lib.ui.popupdialog.Atom(position_parent,
				msg, "icon/22/status/dialog-warning.png");
		},
		
		info: function(position_parent, msg) {
			return new lib.ui.popupdialog.Atom(position_parent,
				msg, "icon/22/status/dialog-information.png");
		}
	}
});
