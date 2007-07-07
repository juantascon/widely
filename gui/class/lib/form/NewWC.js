// data: name, manager, repo_id

qx.Class.define("lib.form.NewWC",
{
	extend: qx.ui.groupbox.GroupBox,
	
	include: [ lib.dao.WC, lib.dao.Repo ],
	
	properties:
	{
		grid: { check: "qx.ui.layout.GridLayout" },
		name_i: { check: "qx.ui.form.TextField" },
		manager_i: { check: "qx.ui.form.ComboBox" },
		repo_i: { check: "qx.ui.form.ComboBoxEx" }
	},
	
	construct: function () {
		this.base(arguments, "Working Copy Info");
		this.setGrid(new qx.ui.layout.GridLayout());
		this.set({left: 0, top: 0, height: "auto", width: "auto"});
		
		this.setName_i(new qx.ui.form.TextField(""));
		this.getName_i().set({left: 0, top: 0, height: "auto", width: "auto"});
		
		this.setManager_i(new qx.ui.form.ComboBox());
		//this.getManager_i().set({left: 0, top: 0, height: "auto", width: "auto"});
		
		var rq_managers = this.wc_manager_list();
		rq_managers.addEventListener("ok", function(e) {
			var m = this.getManager_i();
			var list = e.getData();
			
			for(var i in list) {
				m.add(new qx.ui.form.ListItem(list[i], null, list[i]));
			}
			
			m.setSelected(m.getList().getFirstChild());
		}, this);
		
		
		this.setRepo_i(new qx.ui.form.ComboBoxEx());
		with(this.getRepo_i()) {
			//set({left: 0, top: 0, height: "auto", width: "auto"});
			setColumnHeaders(["ID", "Name", "Manager"]);
			//setShowOnTextField("Name");
		}
		
		var rq_repos = this.repo_list();
		rq_repos.addEventListener("ok", function(e) {
			var r = this.getRepo_i();
			var list = e.getData();
			var selection = [];
			
			for(var i in list) {
				selection.push([ i, list[i]["name"], list[i]["manager"] ]);
			}
			
			r.setSelection(selection);
			r.setSelectedIndex(0);
			
		}, this);
		
		
		
		with(this.getGrid()) {
			set({left: 0, top: 0, height: 80, width: 200});
			setColumnCount(2);
			setRowCount(3);
			
			setColumnWidth(0, "40%");
			setColumnWidth(1, "60%");
			
			setRowHeight(0, "33%");
			setRowHeight(1, "33%");
			setRowHeight(2, "33%");
			
			add(new qx.ui.basic.Label("Name") , 0, 0);
			add(new qx.ui.basic.Label("Manager"), 0, 1);
			add(new qx.ui.basic.Label("Repository"), 0, 2);
			
			add(this.getName_i(), 1, 0);
			add(this.getManager_i(), 1, 1);
			add(this.getRepo_i(), 1, 2);
		}
		
		this.add(this.getGrid());
	},
	
	members:
	{
		show_dialog: function(pmodal) {
			var dialog = new lib.ui.WDialog(pmodal, "New Working Copy", this);
			dialog.addEventListener("ok", function(e) {
				this.debug(this.getName_i().getComputedValue());
				this.debug(this.getManager_i().getSelected().getValue());
				this.debug(this.getRepo_i().getSelectedRow()[1]);
			}, this);
		}
	}
});


