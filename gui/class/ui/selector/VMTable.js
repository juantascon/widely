qx.Class.define("ui.selector.VMTable",
{
	extend: qx.ui.table.Table,
	
	include: dao.Versions,
	
	construct: function () {
		var tm = new qx.ui.table.SimpleTableModel();
		tm.setColumns(["ID", "Description", "Date", "Author"]);
		
		this.base(arguments, tm);
		this.set({height: "100%", width: "100%"});
		
		this.setColumnWidth(0, 20);
		this.setColumnWidth(1, 120);
		this.setColumnWidth(2, 100);
		this.setColumnWidth(3, 60);
		
		this.setStatusBarVisible(false);
		this.getDataRowRenderer().setVisualizeFocusedState(false);
		this.getSelectionModel().setSelectionMode(qx.ui.table.SelectionModel.SINGLE_SELECTION);
		
		this.setBackgroundColor("white");
		this.setBorder(new qx.renderer.border.Border(1, "solid", "#91A5BD"));
		
		this.getSelectionModel().addEventListener("changeSelection", function(e){
			main.Obj.selector.set_version(this.selected_row_id());
		}, this);
		
		this.dao_load();
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
			if (id == "WC") { id = ""+main.Cons.WC }
			return id;
		}
	}
});
