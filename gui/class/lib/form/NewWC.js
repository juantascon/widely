qx.Class.define("lib.form.NewWC",
{
	extend: qx.ui.groupbox.GroupBox,
	
	include: [ lib.dao.api.WC, lib.dao.api.Repo, lib.form.Helper ],
	
	properties:
	{
		grid: { check: "qx.ui.layout.GridLayout" },
		name_i: { check: "qx.ui.form.TextField" },
		manager_i: { check: "qx.ui.form.ComboBoxEx" },
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
			
			this.getRepo_i().addEventListener("changeValue", function(e) {
				d.getOK().setEnabled(true);
			});
			
			return d;
		}
	}
});
