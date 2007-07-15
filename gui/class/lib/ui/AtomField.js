qx.Class.define("lib.ui.AtomField",
{
	extend: qx.ui.layout.HorizontalBoxLayout,
	
	properties:
	{
		atom: { check: "qx.ui.basic.Atom" },
		field: { check: "qx.ui.form.TextField" }
	},
	
	construct: function(label, icon, field) {
		this.base(arguments);
		with(this) {
			set({ left: 0, width: "100%", height: "auto" });
			setVerticalChildrenAlign("middle");
			setSpacing(10);
		}
		
		this.setAtom(new qx.ui.basic.Atom(label, icon));
		with(this.getAtom()) {
			set({ left: 0, width: "40%" });
			setHorizontalChildrenAlign("left");
			setSpacing(7);
		}
		
		this.setField(field);
		with(this.getField()) {
			set({ right: 0, width: "60%" });
		}
		
		this.add(this.getAtom(), this.getField());
	}
});
