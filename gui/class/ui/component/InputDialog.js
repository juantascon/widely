qx.Class.define("ui.component.InputDialog",
{
	extend: ui.component.Dialog,
	
	construct: function (title, message, input_field) {
		if (!input_field){ input_field = new qx.ui.form.TextField(""); }
		
		this.setField(input_field);
		this.getField().setEdge(0,0,0,0);
		this.base(arguments, title, message, this.getField());
	},
	
	properties:
	{
		field: { check: "qx.ui.form.TextField" }
	},
	
	members:
	{
		get_text: function() {
			return this.getField().getComputedValue();
		}
	}
});
