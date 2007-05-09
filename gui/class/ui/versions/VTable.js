qx.Class.define("ui.versions.VTable",
{
	extend: qx.ui.table.Table,
	
	include: dao.Versions,
	
	construct: function () {
		var tm = new qx.ui.table.SimpleTableModel();
		tm.setColumns(["ID", "Description", "Date", "Author"]);
		
		this.base(arguments, tm);
		this.set({height: "1*", width: "100%"});
		
		this.setStatusBarVisible(false);
		
		this.setColumnWidth(0, 20);
		this.setColumnWidth(1, 120);
		this.setColumnWidth(2, 100);
		this.setColumnWidth(3, 60);
		//setMetaColumnCounts([1, -1]);
		this.getSelectionModel().setSelectionMode(qx.ui.table.SelectionModel.SINGLE_SELECTION);
		this.setBackgroundColor(255);
		this.setBorder(new qx.renderer.border.Border(1, "solid", "#91A5BD"));
		this.load();
	},
	
	members:
	{
		load_from_hash: function(data) {
			var tm_data = [];
			
			for (var i in data){
				tm_data.push([data[i]["id"], data[i]["description"], data[i]["date"], data[i]["author"]]);
			}
			
			this.getTableModel().setData(tm_data);
		}
	}
});
