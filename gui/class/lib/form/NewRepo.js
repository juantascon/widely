qx.Class.define("lib.form.NewRepo",
{
	extend: qx.ui.groupbox.GroupBox,
	
	include: [ lib.dao.Repo, lib.form.Helper ],
	
	properties:
	{
		grid: { check: "qx.ui.layout.GridLayout" },
		name_i: { check: "qx.ui.form.TextField" },
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
	}
	
});
