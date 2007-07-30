qx.Class.define("lib.ui.toolbar.Horizontal",
{
	extend: qx.ui.toolbar.ToolBar,
	
	include: lib.ui.toolbar.ToolBar,
	
	construct: function(iconsize) {
		this.base(arguments);
		
		this.initialize_toolbar(iconsize);
		this.set({height: "auto", width: null});
	},
	
	members:
	{
		add_part: function(button_list) {
			var part = new qx.ui.toolbar.Part();
			
			for (var i in button_list) {
				var data = button_list[i];
				switch(data.type)
				{
					case "separator":
						var item = new qx.ui.toolbar.Separator;
						break;
					case "button":
						var item = this.create_button( data.label, data.icon,
							data.permanent, data.execute, data._this);
						break;
				};
				
				part.add(item);
			}
			
			this.add(part);
		}
	}
});
