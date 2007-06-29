qx.Class.define("lib.ui.EditableListView",
{
	extend: qx.ui.layout.GridLayout,
	
	construct: function (header) {
		this.base(arguments);
		
		this.setListview(new qx.ui.listview.ListView([], header));
		with (this.getListview()) {
			set({left: 0, top: 0, height: "100%", width: "100%"});
		}
		
		this.setToolbar(new qx.ui.layout.VerticalBoxLayout);
		with (this.getToolbar()) {
			set({left: 0, top: 0, height: null, width: "auto"});
			setSpacing(10);
			setPaddingLeft(20);
		}
		
		with(this) {
			add_button("Reload", "actions/view-refresh", function(e){
				this.createDispatchEvent("load");
			}, this);
			
			add_button("Add", "actions/edit-add", function(e){
				this.createDispatchEvent("add");
			}, this);
			
			add_button("Delete", "actions/edit-delete", function(e){
				this.createDispatchEvent("delete");
			}, this);
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
	
	properties:
	{
		toolbar: { check: "qx.ui.layout.VerticalBoxLayout" },
		listview: { check: "qx.ui.listview.ListView" }
	},
	
	
	events:
	{
		"load": "qx.event.type.Event",
		"add": "qx.event.type.Event",
		"delete": "qx.event.type.Event"
	},
	
	members:
	{
		add_button: function(label, icon, execute){
			var b = new qx.ui.form.Button(label, "icon/22/"+icon+".png");
			b.set({height: "auto", width: "auto"});
			b.setBorder("outset");
			
			b.addEventListener("execute", execute, this);
			b.setToolTip(new qx.ui.popup.ToolTip(label));
			b.setShow("icon");
			
			this.getToolbar().add(b);
		},
		
		set_data: function(data){
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
