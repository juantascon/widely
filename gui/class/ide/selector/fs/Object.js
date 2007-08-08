/*
 * Un objeto del sistema de archivos (arbol de archivos)
 *
 */
qx.Mixin.define("ide.selector.fs.Object",
{
	include: lib.dao.api.WC,
	
	properties:
	{
		// El nombre del objeto
		name: { check: "String", init: "" },
		
		// El nombre del directorio al que pertenece el objeto
		path: { check: "String", init: ""},
		
		// La version del objeto
		version: { check: "Number" },
		
		// El tipo del objeto <"file"|"dir">
		ftype: { check: ["file", "dir"] }
	},
	
	members:
	{
		/*
		 * Retorna si el objeto es de solo lectura
		 *
		 */
		is_read_only: function() {
			return ( this.getVersion() != cons.WC);
		},
		
		/*
		 * Retorna el nombre completo del objeto
		 *
		 */
		full_name: function() {
			return ( "" + this.getPath() + "/" + this.getName() );
		},
		
		/*
		 * inicia los valores del objeto
		 *
		 * name: el nombre del objeto
		 * path: el nombre del directorio al que pertenece el objeto
		 * version: la version del objeto
		 *
		 */
		initialize_fs_object: function(name, path, version) {
			this.setName(name);
			this.setPath(path);
			this.setVersion(version);
		}
	}
});
