/*
 * Representa un arbol de archivos
 *
 */
qx.Class.define("ide.selector.fs.Tree",
{
	extend: qx.ui.tree.Tree,
	
	include: [ ide.selector.fs.DragAndDrop ],
	
	/*
	 * version: la version del arbol de archivos
	 *
	 */
	construct: function (version) {
		// La version por defecto es cons.WC
		if (qx.util.Validation.isInvalid(eval(version))) { version = cons.WC }
		this.initialize_fs_object("/", "", eval(version));
		
		// El nombre del arbol cambia si es una copia de trabajo
		if ( this.getVersion() == cons.WC ) {
			this.base(arguments, "WorkingCopy");
		}
		// El nombre del arbol contiene la version que representa
		else {
			this.base(arguments, "Version: "+this.getVersion());
		}
		
		this.setFtype("dir");
		
		this.set({height: "100%", width: "100%"});
		this.setBackgroundColor("white");
		this.setOverflow("auto");
		//this.setBorder(new qx.renderer.border.Border(1, "solid", "#91A5BD"));
		
		this.setSelectedElement(this);
		if (! this.is_read_only()) {
			this.set_fs_dropable();
		}
	},
	
	members:
	{
		/*
		 * Permite hacer la peticion al servidor y cargar los datos
		 * del arbol de archivos
		 *
		 */
		load: function(){
			var load_rq = this.wc_ls("/", this.getVersion());
			
			load_rq.addEventListener("ok", function(e) {
				var data = e.getData();
				
				this.destroyContent();
				
				for (var i in data){
					data[i]["version"] = this.getVersion();
					
					// Si un hijo es tipo directorio
					if (data[i]["type"] == "dir"){
						this.addToFolder(ide.selector.fs.Dir.new_from_hash(data[i]));
					}
					
					// Si un hijo es tipo archivo
					if (data[i]["type"] == "file"){
						this.addToFolder(ide.selector.fs.File.new_from_hash(data[i]));
					}
				}
				/* TODO: doc */
				if (! this.is_read_only()) {
					this.load_status();
				}
			}, this);
		},
		
		/*
		 * TODO:  doc
		 */
		load_status: function() {
			var status_rq = this.wc_status();
			
			status_rq.addEventListener("ok", function(e) {
				var data = e.getData();
				
				for (var i in data){
					this.set_child_status(data[i]);
				}
			}, this);
		},
		
		/*
		 * TODO:  doc
		 */
		set_child_status: function(data) {
			if ( data["type"] == "file" ) {
				var obj = this.find_child(""+data["path"] + "/" + data["name"]);
				if (qx.util.Validation.isValid(obj)) {
					obj.set_status(data["status"]);
				}
			}
			
			if ( data["type"] == "dir" ) {
				if ( data["childs"] ) {
					for (var i in data["childs"]) {
						this.set_child_status(data["childs"][i]);
					}
				}
			}
		},
		
		/*
		 * Busca un hijo a partir de la ruta completa y el nombre del
		 * archivo
		 *
		 * full_name: el nombre completo del archivo
		 *
		 */
		find_child: function(full_name) {
			// Todos los hijos de forma recursiva
			var items = this.getItems(true, true);
			
			for (var i in items) {
				// Encontro el archivo
				if (items[i].full_name() == full_name) { return items[i]; }
			}
			
			return null;
		},
		
		/*
		 * Crea un archivo/directorio nuevo dentro del arbol de archivos
		 *
		 * as_dir: true para crear un directorio, false para crear un archivo
		 *
		 */
		new_file: function(as_dir) {
			var dir = null;
			
			// Busca el directorio en donde crear el archivo/directorio
			var selected = this.getSelectedElement();
			if (selected.getFtype() == "dir") {
				dir = selected;
			}
			else {
				dir = selected.getParentFolder();
			}
			
			// Pregunta el nombre del nuevo archivo/directorio
			var name_popup = new lib.ui.popupdialog.Input(dir, "new");
			name_popup.addEventListener("ok", function(e) {
				
				var name = name_popup.get_text();
				var path = dir.full_name();
				
				// Envia la peticion al servidor
				var add_rq = this.wc_add(path+"/"+name, as_dir);
				add_rq.addEventListener("ok", function(e) {
					
					if (as_dir) {
						dir.addToFolder(new ide.selector.fs.Dir(name, path, this.getVersion()));
					}
					else {
						dir.addToFolder(new ide.selector.fs.File(name, path, this.getVersion()));
					}
					
				}, this);
				
				add_rq.addEventListener("fail", function(e) {
					lib.ui.Msg.error(dir, e.getData());
				}, this);
				
			}, this);
		},
		
		/*
		 * Elimina el elemento seleccionado del arbol de archivos
		 *
		 */
		delete_selected: function() {
			var selected = this.getSelectedElement();
			
			// El nombre completo del archivo/directorio seleccionado
			var path = selected.full_name();
			
			var confirm_popup = lib.ui.Msg.warn(selected, "Remove "+path);
			
			confirm_popup.addEventListener("ok", function(e) {
				
				var delete_rq = this.wc_delete(path);
				
				delete_rq.addEventListener("ok", function(e) {
					selected.destroy();
				}, this);
				
				delete_rq.addEventListener("fail", function(e) {
					/*
					 * SVN presenta errores en el momento de borrar un archivo que se
					 * acaba de adicionar, para corregirlo primero se debe hacer un commit
					 *
					 */
					lib.ui.Msg.error(selected, "imposible to delete, try with commit first");
				}, this);
				
			}, this);
		},
		
		/*
		 * Hace un commit de los cambios hechos en la copia de trabajo
		 *
		 */
		commit: function() {
			// Pregunta el nombre de la nueva version
			var name_popup = new lib.ui.popupdialog.Input(this, "version name");
			
			name_popup.addEventListener("ok", function(e) {
				
				var commit_rq = this.wc_commit(name_popup.get_text());
				
				commit_rq.addEventListener("ok", function(e) {
					global.selectorview.getVersionstable().load();
				}, this);
				
				commit_rq.addEventListener("fail", function(e) {
					lib.ui.Msg.error(selected, e.getData());
				}, this);
				
			}, this);
		}
	}
});
