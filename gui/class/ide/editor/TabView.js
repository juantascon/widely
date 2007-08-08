/*
 * La vista de todos los tabs de edicion de archivos
 *
 */

qx.Class.define("ide.editor.TabView",
{
	extend: qx.ui.pageview.tabview.TabView,
	
	properties:
	{
		// La lista de tabs
		tabs: { check: "lib.lang.List", init: new lib.lang.List() },
		
		// El tab seleccionado
		selected: { check: "ide.editor.Tab" }
	},
	
	construct: function () {
		this.base(arguments, "vertical");
		
		this.set({height: "1*", width: "100%"});
		
		/*
		 * Si se cambia el tab seleccionado se debe actualizar el valor
		 * de la propiedad selected y en caso de que el tab sea de solo
		 * lectura se debe colocar el toolbar en modo solo lectura
		 *
		 */
		this.getBar().getManager().addEventListener("changeSelected", function(e) {
			var b = e.getValue();
			
			for (var i = 0; i < this.getTabs().size(); i++){
				if (this.getTabs().get_at(i).getButton() == b){
					this.setSelected(this.getTabs().get_at(i));
					break;
				}
			}
			
			var read_only = this.getSelected().getFile().is_read_only()
			
			// Coloca el toolbar en modo solo lectura
			global.editorview.getToolbar().set_mode_ro(read_only);
		}, this);
	},
	
	members:
	{
		/*
		 * Crear y adiciona un tab en la lista de tabs y lo marca como el tab
		 * seleccionado 
		 *
		 * file: el archivo vinculado al tab
		 *
		 */
		add_tab: function(file){
			/*
			 * En caso de que se quiera adicionar un tab con un archivo que
			 * ya esta abierto se busca el archivo dentro de la lista de tabs
			 * y se marca como seleccionado
			 *
			 */
			for (var i = 0; i < this.getTabs().size(); i++ ){
				var tab = this.getTabs().get_at(i);
				
				if (tab.getFile().full_name() == file.full_name() &&
					tab.getFile().getVersion() == file.getVersion()) {
					
					// Encontro el tab entonces se selecciona
					tab.getButton().setChecked(true);
					return tab;
				}
			}
			
			// Se crea el tab
			var tab = new ide.editor.Tab(file);
			
			this.getBar().add(tab.getButton());
			this.getPane().add(tab.getPage());
			
			/*
			 * Cuando se cierra un tab en caso de que este no sea el ultimo tab
			 * de la lista se debe seleccionar un tab que este contiguo al tab
			 * que se va a cerrar
			 *
			 */
			tab.getButton().addEventListener("closetab", function(e) {
				var b = e.getData();
				var tabs = this.getTabs();
				
				for (var i = 0; i < tabs.size(); i++) {
					// Se encontro el tab que se quiere cerrar
					if (tabs.get_at(i).getButton() == b) {
						// Se elimina el tab
						tabs.get_at(i).dispose();
						
						/*
						 * Se obtiene un tab que sea contiguo a el tab que se
						 * quiere cerrar
						 *
						 */
						var next_tab = tabs.remove(i);
						if ( qx.util.Validation.isValid(next_tab) ) {
							// Se selecciona el tab contiguo
							next_tab.getButton().setChecked(true);
						}
						else {
							/*
							 * Se desactiva el toolbar por que no hay ingun otro
							 * tab abierto
							 *
							 */
							global.editorview.getToolbar().set_mode_disable(true);
						}
						break;
					}
				}
			}, this);
			
			// Se adiciona el tab que se aca de crear
			this.getTabs().add(tab);
			
			// Se marca el tab como seleccionado
			tab.getButton().setChecked(true);
			
			return tab;
		}
	}
});
