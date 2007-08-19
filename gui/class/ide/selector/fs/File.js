/*
 * Representacion de un archivo del arbol de archivos
 *
 */
qx.Class.define("ide.selector.fs.File",
{
	extend: qx.ui.tree.TreeFile,
	
	include: [ ide.selector.fs.DragAndDrop, lib.dao.api.Compiler ],
	
	/*
	 * name: el nombre del archivo
	 * path: el directorio padre del archivo
	 * version: la version del archivo
	 *
	 */
	construct: function (name, path, version) {
		this.base(arguments, name);
		this.setFtype("file");
		this.initialize_fs_object(name, path, version);
		
		this.addEventListener("click", function(e){
			global.editorview.getTabview().add_tab(this);
		}, this);
		
		/*
		 * El Drag and Drop (mover) y la opcion de renombrar solo estan
		 * activos si el arbol no es de solo lectura
		 *
		 */
		if (! this.is_read_only()) {
			this.set_fs_dragable();
			this.set_fs_renameable();
		}
	},
	
	members:
	{
		/*
		 * Pinta el fondo del archivo en el arbol de acuerdo a su estado con respecto
		 * al repositorio
		 *
		 * status: el estado del archivo
		 *
		 */
		set_status: function(status) {
			switch (status) {
				case ide.selector.fs.Status.NORMAL:
					break;
				case ide.selector.fs.Status.MODIFIED:
					this.getLabelObject().setBackgroundColor("#FAFFCC");// Yellow
					break;
				case ide.selector.fs.Status.ADDED:
					this.getLabelObject().setBackgroundColor("#BBDDBB");// Green
					break;
				case ide.selector.fs.Status.NOCONTROL:
					this.getLabelObject().setBackgroundColor("#FFA0FF");// Purple
					
					break;
				case ide.selector.fs.Status.DELETED:
					this.getLabelObject().setBackgroundColor("red");
					break;
				case ide.selector.fs.Status.CONFLICTED:
					this.getLabelObject().setBackgroundColor("#FF7355"); // Red
					break;
				default:
					this.getLabelObject().setBackgroundColor("black");
					break;
			}
		},
		
		/*
		 * Compila este archivo utilizando el compilador javac
		 *
		 */
		compile_javac: function() {
			var compile_rq = this.compiler_compile("javac", this.full_name());
			
			compile_rq.addEventListener("fail", function(e) {
				lib.ui.Msg.error(global.editorview, "Compiler errors: "+e.getData());
			});
		}
	},
	
	statics:
	{
		/*
		 * Crea un nuevo archivo a partir de un hash
		 *
		 * h: el hash don la informacion del archivo
		 */
		new_from_hash: function(h){
			return new ide.selector.fs.File(h["name"], h["path"], h["version"]);
		}
		
	}
});
