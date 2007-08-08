/*
 * Tab Para la administracion de los copias de trabajo del usuario
 *
 */
qx.Class.define("config.tab.WC",
{
	extend: lib.ui.PageViewTab,
	
	include: lib.dao.api.WC,
	
	properties:
	{
		// La lista de copias de trabajo
		editablelistview: { check: "lib.ui.EditableListView" }
	},
	
	construct: function () {
		this.base(arguments,
			"buttonview",
			"Working Copies",
			"icon/32/places/document-folder.png");
		
		this.setEditablelistview(new lib.ui.EditableListView( {
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
		
		with (this.getEditablelistview()) {
			
			// Cargar una copia de trabajo
			addEventListener("load", function(e){
				var wrq = this.wc_list();
				wrq.addEventListener("ok", function(e){
					this.load_list(e.getData());
					this.getEditablelistview().toggleDisplay();
					this.getEditablelistview().toggleDisplay();
				}, this);
			}, this);
			createDispatchEvent("load");
			
			// Crear una copia de trabajo
			addEventListener("add", function(e) {
				// Se llama a la forma encargada del proceso de creacion de repositorios
				var form = new lib.form.NewWC();
				
				form.run(this, function(e) {
					this.createDispatchEvent("load");
				}, this);
			}, this.getEditablelistview());
			
			/*
			 * Cuando se debe eliminar una copia de trabajo tambien se borran todas
			 * los archivos de la copia de trabajo
			 *
			 */
			addEventListener("delete", function(e) {
				var wc_name = this.getEditablelistview().selected("name");
				
				var confirm_dialog = lib.ui.Msg.warn( this.getEditablelistview(),
					"Delete?: "+wc_name+" all its content and child elements will be lost");
				
				confirm_dialog.addEventListener("ok", function(e) {
					var destroy_rq = this.wc_destroy(wc_name);
					destroy_rq.addEventListener("ok", function(e) {
						this.getEditablelistview().createDispatchEvent("load");
					}, this);
				},this);
			}, this);
		}
		
		this.getPage().add(this.getEditablelistview());
		this.getPage().setPadding(50);
	},
	
	members:
	{
		/*
		 * Carga la lista de copias de trabajo
		 *
		 * data: los datos de las copias de trabajo
		 *
		 */
		load_list: function(data){
			while(this.getEditablelistview().getListview().getData().pop());
			
			for (var i in data){
				this.getEditablelistview().getListview().getData().push({
					name: {text: data[i]["name"]},
					manager: {text: data[i]["manager"]},
					repo: {text: data[i]["repo"]}
				});
			}
		}
	}
});
