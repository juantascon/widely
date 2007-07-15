qx.Class.define("lib.form.NewUser",
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
		
		this.setName_i(new qx.ui.form.TextField(""));
		this.setRepo_i(this.create_combobox( ["name", "manager"], this.repo_list() ));
		this.setManager_i(this.create_combobox( ["name", "description"], this.wc_manager_list() ));
		
		this.setGrid(this.create_grid(
			[ "Name", "Manager", "Repository" ],
			[ this.getName_i(), this.getManager_i(), this.getRepo_i() ],
			80, 200
		));
		
		this.add(this.getGrid());
	}
	
});
