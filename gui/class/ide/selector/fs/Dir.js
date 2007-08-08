/*
 * Representacion de un directorio del arbol de archivos
 *
 */
qx.Class.define("ide.selector.fs.Dir",
{
	extend: qx.ui.tree.TreeFolder,
	
	include: [ ide.selector.fs.DragAndDrop ],
	
	/*
	 * name: el nombre del directorio
	 * path: el nombre del directorio al que pertence
	 * version: la version del directorio
	 *
	 */
	construct: function (name, path, version) {
		this.base(arguments, name);
		this.setFtype("dir");
		this.initialize_fs_object(name, path, version);
		
		/*
		 * El Drag and Drop (mover) y la opcion de renombrar solo estan
		 * activos si el arbol no es de solo lectura
		 *
		 */
		if (! this.is_read_only()) {
			this.set_fs_dragable();
			this.set_fs_dropable();
			this.set_fs_renameable();
		}
	},
	
	statics:
	{
		/*
		 * Crea un directorio a partir de un has
		 * es posible que se incluyan los hijos del directorio
		 * tambien
		 *
		 * h: el hash don la informacion del directorio
		 *
		 */
		new_from_hash: function(h){
			var dir = new ide.selector.fs.Dir(h["name"], h["path"], h["version"]);
			
			// Si el directorio tiene hijos
			if ( h["childs"] ) {
				for (var i in h["childs"]) {
					h["childs"][i]["version"] = h["version"];
					
					// Si el hijo es un directorio
					if (h["childs"][i]["type"] == "dir"){
						dir.addToFolder(ide.selector.fs.Dir.new_from_hash(h["childs"][i]));
					}
					
					// Si el hijo es un archivo
					if (h["childs"][i]["type"] == "file"){
						dir.addToFolder(ide.selector.fs.File.new_from_hash(h["childs"][i]));
					}
				}
			}
			
			return dir;
		}
	}
});
