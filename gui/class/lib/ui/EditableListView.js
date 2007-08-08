/*
 * Una lista de valores unido con un toolbar
 * que permite la edicion de los valores(agregar, borrar)
 * y la actualizacion de los datos desde el servidor
 *
 */
qx.Class.define("lib.ui.EditableListView",
{
	extend: qx.ui.layout.GridLayout,
	
	events:
	{
		// Cuando se deben (re)cargar los datos
		"load": "qx.event.type.Event",
		// Cuando se debe adicionar un dato
		"add": "qx.event.type.Event",
		// Cuando se debe borrar un dato
		"delete": "qx.event.type.Event"
	},
	
	properties:
	{
		toolbar: { check: "lib.ui.toolbar.Vertical" },
		listview: { check: "qx.ui.listview.ListView" }
	},
	
	/*
	 * header: las cabezeras de la lista de valores
	 */
	construct: function (header) {
		this.base(arguments);
		
		this.setListview(new qx.ui.listview.ListView([], header));
		with (this.getListview()) {
			set({left: 0, top: 0, height: "100%", width: "100%"});
			
			/*
			 * inicialmente el toolbar esta en modo solo lectura
			 * si se selecciona algun valor de la lista se debe activar
			 * desactivar
			 *
			 */
			getPane().getManager().addEventListener("changeSelection", function(e) {
				this.getToolbar().set_mode_ro(false);
			}, this);
		}
		
		this.setToolbar(new lib.ui.toolbar.Vertical(22));
		with (this.getToolbar()) {
			set({left: 0, top: 0});
			setSpacing(10);
			setPaddingLeft(20);
			
			add_button("Reload", "actions/view-refresh", true, function(e){
				this.createDispatchEvent("load");
			}, this);
			
			add_button("Add", "actions/edit-add", true, function(e){
				this.createDispatchEvent("add");
			}, this);
			
			add_button("Delete", "actions/edit-delete", false, function(e){
				this.createDispatchEvent("delete");
			}, this);
			
			set_mode_ro(true);
		}
		
		with(this) {
			set({left: 0, top: 0, height: "100%", width: "100%"});
			setColumnCount(2);
			setRowCount(3);
			
			setColumnWidth(0, "90%");
			setColumnWidth(1, "10%");
			
			setRowHeight(0, "30%");
			setRowHeight(1, "40%");
			setRowHeight(2, "30%");
			
			mergeCells(0, 0, 1, 3);
			add(this.getListview(), 0, 0);
			add(this.getToolbar(), 1, 1);
		}
	},
	
	members:
	{
		/*
		 * Retorna el valor de un campo del elemento de la lista de valores
		 * seleccionado.
		 *
		 * field: el nombre del campo del elemento
		 */
		selected: function(field) {
			var item = this.getListview().getPane().getSelectedItem();
			if ( qx.util.Validation.isValid(item) &&
				qx.util.Validation.isValid(item[field]) ) {
				
				return item[field].text
			}
			
			return null;
		}
	}
});
