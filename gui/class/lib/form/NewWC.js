/*
 * Esta forma permite crear una copia de trabajo nueva
 *
 */
qx.Class.define("lib.form.NewWC",
{
	extend: qx.ui.groupbox.GroupBox,
	
	include: [ lib.dao.api.WC, lib.dao.api.Repo, lib.form.Helper ],
	
	properties:
	{
		grid: { check: "qx.ui.layout.GridLayout" },
		// El nombre de la copia de trabajo
		name_i: { check: "qx.ui.form.TextField" },
		// El manejador de la copia de trabajo
		manager_i: { check: "qx.ui.form.ComboBoxEx" },
		// El repositorio de la copia de trabajo
		repo_i: { check: "qx.ui.form.ComboBoxEx" }
	},
	
	construct: function () {
		this.base(arguments, "Working Copy Info");
		this.set({left: 0, top: 0, height: "auto", width: "auto"});
		
		var repo_list_rq = this.repo_list();
		repo_list_rq.addEventListener("ok", function(e) {
			if (e.getData().length < 1) {
				
				lib.ui.Msg.error(this.getRepo_i(), "Empty Repository list, please create one first");
			}
		}, this);
		
		this.setName_i(new qx.ui.form.TextField(""));
		this.setRepo_i(this.create_combobox( ["name", "manager"], repo_list_rq ));
		this.setManager_i(this.create_combobox( ["name", "description"], this.wc_manager_list() ));
		
		this.setGrid(this.create_grid(
			[ "Name", "Manager", "Repository" ],
			[ this.getName_i(), this.getManager_i(), this.getRepo_i() ],
			80, 200
		));
		
		this.add(this.getGrid());
	},
	
	members:
	{
		/*
		 * Ejecuta la forma dentro de un dialogo
		 *
		 * pmodal: el padre del dialogo
		 * callback: la funcion a ejecutar cuando se haya creado la copia de trabajo
		 * _this: el objeto this del callback
		 *
		 */
		run: function(pmodal, callback, _this){
			var d = this.create_dialog(pmodal, "New User");
			d.getOK().setEnabled(false);
			
			d.addEventListener("ok", function(e) {
				
				var create_rq = this.wc_create(
					this.getName_i().getComputedValue(),
					this.getRepo_i().getSelectedRow()[1],
					this.getManager_i().getSelectedRow()[1] );
				
				create_rq.addEventListener("ok", callback, _this);
				
			}, this);
			
			/*
			 * El boton aceptar de la forma debe permanecer desactivado hasta
			 * que se hayan cargado los posibles valores para el repositorio
			 *
			 */
			this.getRepo_i().addEventListener("changeValue", function(e) {
				d.getOK().setEnabled(true);
			});
			
			return d;
		}
	}
});
