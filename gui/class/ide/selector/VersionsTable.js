qx.Class.define("ide.selector.VersionsTable",
{
	extend: qx.ui.table.Table,
	
	include: lib.dao.api.WC,
	
	construct: function () {
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
			
			addEventListener("changeSelection", function(e){
				var s = global.selectorview;
				s.set_filetree_version(this.selected_row_id());
				s.getToolbar().set_mode_ro(s.getFiletree().is_read_only());
			}, this);
		}
	},
	
	members:
	{
		load_from_hash: function(data) {
			var tm_data = [];
			
			for (var i in data){
				tm_data.push([data[i]["id"], data[i]["description"], data[i]["date"], data[i]["author"]]);
			}
			tm_data[0] = ["0", "Initial Version", 0, ""];
			tm_data.push(["WC", "Working Copy", 0, ""]);
			
			this.getTableModel().setData(tm_data);
			this.getSelectionModel().setSelectionInterval(0,tm_data.length-1);
		},
		
		selected_row_id: function(){
			var row = this.getSelectionModel().getSelectedRanges()[0]["maxIndex"];
			var id = ""+this.getTableModel().getData()[row][0];
			if (id == "WC") { id = ""+cons.WC }
			return id;
		},
		
		load: function(){
			var rq = this.wc_version_list();
			rq.addEventListener("ok", function(e) {
				this.load_from_hash(e.getData());
			}, this);
		}
	}
});
