/*
 * Enumeracion de los posibles estados de un archivo
 * mas informacion: server/webservices/repo/status
 *
 */
qx.Class.define("ide.selector.fs.Status",
{
	type: "static",
	
	statics:
	{
		// Sin cambios
		NORMAL: 0,
		
		// El archivo ha sido cambiado
		MODIFIED: 1,
		
		// El archivo esta marcado para adicion
		ADDED: 2,
		
		// El archivo no esta bajo control de versiones
		NOCONTROL: 3,
		
		// El archivo esta marcado para borrado
		DELETED: 4,
		
		// El archivo tiene conflictos con relacion a commits anteriores
		CONFLICTED: 5
	}
});
