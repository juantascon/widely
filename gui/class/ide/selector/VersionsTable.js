/*
 * Tabla con la lista de versiones de una copia de trabajo
 *
 */
qx.Class.define("ide.selector.VersionsTable",
{
	extend: qx.ui.table.Table,
	
	include: lib.dao.api.WC,
	
	construct: function () {
		// La lista es representada por una tabla de datos
		var tm = new qx.ui.table.model.Simple();
		tm.setColumns(["ID", "Description", "Date", "Author"]);
		
		this.base(arguments, tm);
		
		with(this) {
			set({height: "100%", width: "100%"});
			setOverflow("auto");
			setBackgroundColor("white");
			setStatusBarVisible(false);
			
			setColumnWidth(0, 20);
			setColumnWidth(1, 120);
			setColumnWidth(2, 100);
			setColumnWidth(3, 60);
			
			getDataRowRenderer().setVisualizeFocusedState(false);
			
		}
		
		with (this.getSelectionModel()) {
			setSelectionMode(qx.ui.table.selection.Model.SINGLE_SELECTION);
			
			/*
			 * En caso de que se cambie la version seleccionada se debe modificar el arbol
			 * de archivos
			 *
			 */
			addEventListener("changeSelection", function(e){
				var s = global.selectorview;
				// Se cambia la version actual del arbol de archivos
				s.set_tree_version(this.selected_row_id());
				/*
				 * Se cambia el toolbar a modo solo lectura cuando el arbol de archivos
				 * es de solo lectura
				 *
				 */
				s.getToolbar().set_mode_ro(s.getTree().is_read_only());
			}, this);
		}
	},
	
	members:
	{
		/*
		 * Lanza la peticion al servidor para cargar la lista de
		 * versiones
		 *
		 */
		load: function(){
			var rq = this.wc_version_list();
			rq.addEventListener("ok", function(e) {
				var tm_data = [];
				var data = e.getData();
				
				for (var i in data){
					tm_data.push([data[i]["id"], data[i]["description"], data[i]["date"], data[i]["author"]]);
				}
				
				/*
				 * Adiciona las versiones especiales:
				 *
				 * 0: la version inicial
				 * WC: la copia de trabajo actual
				 *
				 */
				tm_data[0] = ["0", "Initial Version", 0, ""];
				tm_data.push(["WC", "Working Copy", 0, ""]);
				
				this.getTableModel().setData(tm_data);
				/*
				 * Selecciona por defecto la ultima version de la lista de versiones,
				 * la copia de trabajo
				 *
				 */
				this.getSelectionModel().setSelectionInterval(0,tm_data.length-1);
				
			}, this);
		},
		
		/*
		 * Permite hacer update/checkout en la copia de trabajo desde
		 * el repositorio, cuando esta selccionada la version WC hace
		 * update y cuando no hace checkout
		 *
		 */
		update_checkout: function() {
			var version = this.selected_row_id();
			
			if (version == cons.WC) {
				var confirm_popup = lib.ui.Msg.warn(global.selectorview, "Update WC from Repository?");
				
				confirm_popup.addEventListener("ok", function(e) {
					var update_rq = this.wc_update();
					
					update_rq.addEventListener("ok", function(e) {
						global.selectorview.getTree().load();
					}, this);
				}, this);
				
			}
			else {
				var confirm_popup = lib.ui.Msg.warn(global.selectorview, "Checkout to version: "+version+" ?");
				
				confirm_popup.addEventListener("ok", function(e) {
					var checkout_rq = this.wc_checkout(version);
					
					checkout_rq.addEventListener("ok", function(e) {
						global.selectorview.set_tree_version(cons.WC);
					}, this);
				}, this);
			}
		},
		
		/*
		 * Retorna el id de la version seleccionada actualmente
		 * Si esta seleccionada la version WC retorna el valor de la
		 * variable gloabl cons.WC
		 *
		 */
		selected_row_id: function(){
			var row = this.getSelectionModel().getSelectedRanges()[0]["maxIndex"];
			var id = ""+this.getTableModel().getData()[row][0];
			if (id == "WC") { id = ""+cons.WC }
			return id;
		}
	}
});
