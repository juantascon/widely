/*
 * Representacion  de un archivo del arbol de archivos
 *
 */
qx.Class.define("ide.selector.fs.File",
{
	extend: qx.ui.tree.TreeFile,
	
	include: [ ide.selector.fs.DragAndDrop ],
	
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
