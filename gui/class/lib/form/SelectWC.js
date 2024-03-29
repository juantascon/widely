/*
 * Esta forma permite a un usuario seleccionar una de sus copias
 * de trabajo disponibles
 *
 */
qx.Class.define("lib.form.SelectWC",
{
	extend: qx.ui.groupbox.GroupBox,
	
	include: [ lib.dao.api.WC, lib.form.Helper ],
	
	properties:
	{
		// La lista de copias de trabajo disponibles
		listview: { check: "qx.ui.listview.ListView" }
	},
	
	construct: function () {
		this.base(arguments, "Working Copy List");
		this.set({left: 0, top: 0, height: "auto", width: "auto"});
		
		this.setListview(new qx.ui.listview.ListView([], {
			name: {
				label: "Name",
				icon: "icon/16/categories/applications-development.png",
				width: "33%",
				type: "text"
			},
			manager: {
				label: "Manager",
				icon: "icon/16/apps/accessories-archiver.png",
				width: "33%",
				type: "text"
			},
			repo: {
				label: "Repository",
				icon: "icon/16/places/archive-folder.png",
				width: "33%",
				type: "text"
			}
		} ));
		
		this.getListview().set({left: 0, top: 0, height: 200, width: 300});
		
		var wrq = this.wc_list();
		wrq.addEventListener("ok", function(e){
			// Si no hay ninguna copia de trabajo se debe mostrar un mensaje de error
			if (e.getData().length < 1) {
				lib.ui.Msg.error(this, "Empty Working Copy list, you can create one in the config page");
			}
			else {
				this.load_list(e.getData());
				this.getListview().toggleDisplay();
				this.getListview().toggleDisplay();
			}
		}, this);
		
		this.add(this.getListview());
	},
	
	members:
	{
		/*
		 * Carga la lista de valores de las copias de trabajo
		 *
		 * data: los datos para cargar la lista
		 */
		load_list: function(data){
			while(this.getListview().getData().pop());
			
			for (var i in data){
				this.getListview().getData().push({
					name: {text: data[i]["name"]},
					manager: {text: data[i]["manager"]},
					repo: {text: data[i]["repo"]}
				});
			}
		},
		
		/*
		 * Retorna el valor de un campo del elemento seleccionado
		 *
		 * field: el campo del elemento seleccionado
		 *
		 */
		selected: function(field) {
			var item = this.getListview().getPane().getSelectedItem();
			if ( qx.util.Validation.isValid(item) &&
				qx.util.Validation.isValid(item[field]) ) {
				
				return item[field].text
			}
			
			return null;
		},
		
		/*
		 * Ejecuta la forma en un dialogo
		 *
		 * pmodal: el padre del dialogo
		 *
		 */
		run: function(pmodal) {
			var d = this.create_dialog(pmodal, "Select Working Copy");
			d.getOK().setEnabled(false);
			
			/*
			 * El boton aceptar del dialogo debe permanecer desabilitado hasta que se
			 * cargue la lista de copias de trabajo
			 */
			this.getListview().getPane().getManager().addEventListener("changeSelection", function(e) {
				d.getOK().setEnabled(true);
			});
			
			return d;
		}
	}
});
