/*
 * Tab Para la administracion de los repositorios del usuario
 *
 */
qx.Class.define("config.tab.Repo",
{
	extend: lib.ui.PageViewTab,
	
	include: lib.dao.api.Repo,
	
	properties:
	{
		// La lista de repositorios del usuarios
		editablelistview: { check: "lib.ui.EditableListView" }
	},
	
	construct: function () {
		this.base(arguments,
			"buttonview",
			"Repositories",
			"icon/32/places/archive-folder.png");
		
		this.setEditablelistview(new lib.ui.EditableListView( {
			name: {
				label: "Name",
				icon: "icon/16/categories/applications-development.png",
				width: "50%",
				type: "text"
			},
			manager: {
				label: "Manager",
				icon: "icon/16/apps/accessories-archiver.png",
				width: "50%",
				type: "text"
			}
		} ));
		
		with (this.getEditablelistview()) {
			
			// Cargar la lista de repositorios
			addEventListener("load", function(e){
				var wrq = this.repo_list();
				wrq.addEventListener("ok", function(e){
					this.load_list(e.getData());
					this.getEditablelistview().toggleDisplay();
					this.getEditablelistview().toggleDisplay();
				}, this);
			}, this);
			createDispatchEvent("load");
			
			// Agregar un repositorio
			addEventListener("add", function(e) {
				// Se llama a la forma encargada del proceso de creacion de repositorios
				var form = new lib.form.NewRepo();
				form.run(this, function(e) {
					this.createDispatchEvent("load");
				}, this);
			}, this.getEditablelistview());
			
			/*
			 * Cuando se debe eliminar un repositorio, tambien se borran todas
			 * las copias de trabajo del repositorio
			 *
			 */
			addEventListener("delete", function(e) {
				var repo_name = this.getEditablelistview().selected("name");
				
				var confirm_dialog = lib.ui.Msg.warn(this.getEditablelistview(),
					"Delete?: "+repo_name+" all its content and child elements will be lost");
				
				confirm_dialog.addEventListener("ok", function(e) {
					var destroy_rq = this.repo_destroy(repo_name);
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
		 * Carga la lista de repositorios
		 *
		 * data: los datos de los repositorios
		 *
		 */
		load_list: function(data){
			while(this.getEditablelistview().getListview().getData().pop());
			
			for (var i in data){
				this.getEditablelistview().getListview().getData().push({
					name: {text: data[i]["name"]},
					manager: {text: data[i]["manager"]}
				});
			}
		}
	}
});
