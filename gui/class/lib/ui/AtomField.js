/*
 * Un campo de texto unido con un mensaje y un icono
 *
 */
qx.Class.define("lib.ui.AtomField",
{
	extend: qx.ui.layout.HorizontalBoxLayout,
	
	properties:
	{
		// La imagen y el icono
		atom: { check: "qx.ui.basic.Atom" },
		// El campo de texto
		field: { check: "qx.ui.form.TextField" }
	},
	
	/*
	 * label: el mensaje
	 * icon: el icono
	 * field: el campo de texto
	 *
	 */
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
