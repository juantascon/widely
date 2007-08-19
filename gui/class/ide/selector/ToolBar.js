/*
 * ToolBar de la vista de seleccion de archivos
 *
 */
qx.Class.define("ide.selector.ToolBar",
{
	extend: lib.ui.toolbar.Horizontal,
	
	construct: function () {
		this.base(arguments, 22);
		
		this.add_part([
			{
				// Boton para crear un archivo nuevo
				type: "button", permanent: false,
				label: "New File",icon: "actions/document-new",
				execute: function(e){
					global.selectorview.getTree().new_file(false);
				}
			},
			{
				// Boton para crear un directorio nuevo
				type: "button", permanent: false,
				label: "New Dir",icon: "actions/folder-new",
				execute: function(e){
					global.selectorview.getTree().new_file(true);
				}
			},
			{
				// Boton para borrar el archivo/direcotorio seleccionado
				type: "button", permanent: false,
				label: "Delete",icon: "actions/edit-delete",
				execute: function(e){
					global.selectorview.getTree().delete_selected();
				}
			}
		]);
		
		this.add_part([
			{
				// Boton para hacer commit al repositorio
				type: "button", permanent: false,
				label: "Commit",icon: "actions/go-down",
				execute: function(e){
					global.selectorview.getTree().commit();
				}
			},
			{
				// Boton para hacer checkout o update desde el repositorio
				type: "button", permanent: true,
				label: "Update/Checkout",icon: "actions/go-up",
				execute: function(e){
					global.selectorview.getVersionstable().update_checkout();
				}
			}
		]);
		
		this.add_part([
			{
				// Boton para recargar la lista de versiones
				type: "button", permanent: true,
				label: "Reload",icon: "actions/view-refresh",
				execute: function(e){
					global.selectorview.getVersionstable().load();
				}
			}
		]);
		
		this.set_mode_ro(true);
	}
});
