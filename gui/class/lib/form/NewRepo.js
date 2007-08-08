/*
 * Esta forma permite crear un repositorio nuevo
 *
 */
qx.Class.define("lib.form.NewRepo",
{
	extend: qx.ui.groupbox.GroupBox,
	
	include: [ lib.dao.api.Repo, lib.form.Helper ],
	
	properties:
	{
		grid: { check: "qx.ui.layout.GridLayout" },
		// El nombre del repositorio
		name_i: { check: "qx.ui.form.TextField" },
		// El manejador del repositorio
		manager_i: { check: "qx.ui.form.ComboBoxEx" }
	},
	
	construct: function () {
		this.base(arguments, "Repository Info");
		this.set({left: 0, top: 0, height: "auto", width: "auto"});
		
		this.setName_i(new qx.ui.form.TextField(""));
		this.setManager_i(this.create_combobox( ["name", "description"], this.repo_manager_list() ));
		
		this.setGrid(this.create_grid(
			[ "Name", "Manager" ],
			[ this.getName_i(), this.getManager_i() ],
			45, 200
		));
		
		this.add(this.getGrid());
	},
	
	members:
	{
		/*
		 * Ejecuta la forma dentro de un dialogo
		 *
		 * pmodal: el padre del dialogo
		 * callback: la funcion a ejecutar cuando se haya creado el repositorio
		 * _this: el objeto this del callback
		 *
		 */
		run: function(pmodal, callback, _this){
			var d = this.create_dialog(pmodal, "New User");
			
			d.addEventListener("ok", function(e) {
				
				var create_rq = this.repo_create(
					this.getName_i().getComputedValue(),
					this.getManager_i().getSelectedRow()[1] );
				
				create_rq.addEventListener("ok", callback, _this);
				
			}, this);
		}
	}
});
