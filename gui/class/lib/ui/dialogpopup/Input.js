qx.Class.define("lib.ui.dialogpopup.Input",
{
	extend: lib.ui.dialogpopup.Base,
	
	properties:
	{
		field: { check: "qx.ui.form.TextField" }
	},
	
	construct: function (parent, init_label) {
		if (!init_label){ init_label = ""; }
		
		this.setField(new qx.ui.form.TextField(init_label));
		with (this.getField()) {
			setEdge(0,0,0,0);
			
		}
		
		this.base(arguments, parent, this.getField());
	},
	
	members:
	{
		get_text: function() {
			return this.getField().getComputedValue();
		}
	}
});
