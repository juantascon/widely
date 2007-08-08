/*
 * El tab para administrar los usuarios
 * permite la creacion adicion y modificacion de los  usuario
 *
 */
qx.Class.define("admin.tab.User",
{
	extend: lib.ui.PageViewTab,
	
	include: [ lib.dao.api.User, lib.dao.api.Auth ],
	
	
	properties:
	{
		// La lista de los usuario
		editablelistview: { check: "lib.ui.EditableListView" }
	},
	
	construct: function () {
		this.base(arguments,
			"buttonview",
			"Users",
			"icon/32/apps/system-users.png");
		
		this.setEditablelistview(new lib.ui.EditableListView( {
			user_id: {
				label: "User ID",
				icon: "icon/16/apps/system-users.png",
				width: "100%",
				type: "text"
			}
		} ));
		
		with (this.getEditablelistview()) {
			// Cargar la lista de usuarios
			addEventListener("load", function(e){
				var list_rq = this.user_list();
				list_rq.addEventListener("ok", function(e){
					this.load_list(e.getData());
					this.getEditablelistview().toggleDisplay();
					this.getEditablelistview().toggleDisplay();
				}, this);
			}, this);
			createDispatchEvent("load");
			
			// Agregar un usuario
			addEventListener("add", function(e) {
				var form = new lib.form.NewUser();
				form.run(this, function(e) {
					this.createDispatchEvent("load");
				}, this);
			}, this.getEditablelistview());
			
			// Eliminar un usuario
			addEventListener("delete", function(e) {
				var user_id = this.getEditablelistview().selected("user_id");
				
				var confirm_dialog = lib.ui.Msg.warn( this.getEditablelistview(),
					"Delete?: "+user_id+" all its content and child elements will be lost");
				
				confirm_dialog.addEventListener("ok", function(e) {
					var destroy_rq = this.user_destroy(user_id);
					destroy_rq.addEventListener("ok", function(e) {
						this.getEditablelistview().createDispatchEvent("load");
					}, this);
				},this);
			}, this);
		}
		
		/*
		 * Adiciona un boton en la barra de herramientas de la lista de
		 * usuarios que permite editar las opciones de un usuario
		 *
		 */
		with(this.getEditablelistview().getToolbar()) {
			add_button("Edit User Config", "actions/edit", false, function(e) {
				var user_id = this.getEditablelistview().selected("user_id");
				
				// Hace una peticion de una session para el usuario seleccionado
				var user_session_rq = this.auth_user_session(user_id);
				user_session_rq.addEventListener("ok", function(e) {
					var session_id = e.getData();
					
					// Guarda la session para entrar en la configuracion del usuario
					lib.dao.Cookie.set_session_id("config", session_id);
					this.debug(user_id);
					
					// Abre una nueva ventana con la configuracion del usuario
					var config_window = new qx.client.NativeWindow("./config.html");
					config_window.open();
				}, this);
			}, this);
			
			set_mode_ro(true);
		}
		
		this.getPage().add(this.getEditablelistview());
		this.getPage().setPadding(50);
	},
	
	members:
	{
		/*
		 * Carga la lista de usuarios
		 *
		 * data: los datos de los usuarios
		 *
		 */
		load_list: function(data){
			while(this.getEditablelistview().getListview().getData().pop());
			
			for (var i in data){
				this.getEditablelistview().getListview().getData().push({
					user_id: {text: data[i]["user_id"]}
				});
			}
		}
	}
});
