qx.Class.define("lib.ui.EditableListView",
{
	extend: qx.ui.layout.GridLayout,
	
	events:
	{
		"load": "qx.event.type.Event",
		"add": "qx.event.type.Event",
		"delete": "qx.event.type.DataEvent"
	},
	
	properties:
	{
		toolbar: { check: "lib.ui.ToolBar" },
		listview: { check: "qx.ui.listview.ListView" },
		selected: { check: "String" }
	},
	
	construct: function (header) {
		this.base(arguments);
		
		this.setListview(new qx.ui.listview.ListView([], header));
		with (this.getListview()) {
			set({left: 0, top: 0, height: "100%", width: "100%"});
			
			getPane().getManager().addEventListener("changeSelection", function(e) {
				this.getToolbar().set_mode_ro(false);
			}, this);
		}
		
		this.setToolbar(new lib.ui.ToolBar("vertical", 22));
		with (this.getToolbar()) {
			setSpacing(10);
			setPaddingLeft(20);
			
			add_button("Reload", "actions/view-refresh", true, function(e){
				this.createDispatchEvent("load");
			}, this);
			
			add_button("Add", "actions/edit-add", true, function(e){
				this.createDispatchEvent("add");
			}, this);
			
			add_button("Delete", "actions/edit-delete", false, function(e){
				this.createDispatchDataEvent("delete", "hola");
			}, this);
			
			set_mode_ro(true);
		}
		
		with(this) {
			set({left: 0, top: 0, height: "100%", width: "100%"});
			setColumnCount(2);
			setRowCount(3);
			
			setColumnWidth(0, "90%");
			setColumnWidth(1, "10%");
			
			setRowHeight(0, "30%");
			setRowHeight(1, "40%");
			setRowHeight(2, "30%");
			
			mergeCells(0, 0, 1, 3);
			add(this.getListview(), 0, 0);
			add(this.getToolbar(), 1, 1);
		}
	},
	
	members:
	{
		selected: function(field) {
			var item = this.getListview().getPane().getSelectedItem();
			if ( qx.util.Validation.isValid(item) &&
				qx.util.Validation.isValid(item[field]) ) {
				
				return item[field].text
			}
			
			return null;
		},
		
		set_data: function(data) {
			while(this.getListview().getData().pop());
			
			for (var i in data){
				this.getListview().getData().push({
					name: {text: data[i]["name"]},
					manager: {text: data[i]["manager"]}
				});
			}
		}
	}
});
