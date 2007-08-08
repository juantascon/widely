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
			set({height: "84%", width: "100%"});
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
		 * Carga la tabla de versiones
		 *
		 * data: la lista de versiones
		 *
		 */
		load_from_hash: function(data) {
			var tm_data = [];
			
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
		},
		
		/*
		 * Lanza la peticion al servidor para cargar la lista de
		 * versiones
		 *
		 */
		load: function(){
			var rq = this.wc_version_list();
			rq.addEventListener("ok", function(e) {
				this.load_from_hash(e.getData());
			}, this);
		}
	}
});
