qx.Class.define("lib.ui.ToolBar",
{
	extend: qx.ui.layout.HorizontalBoxLayout,
	
	properties:
	{
		buttons: { check: "Object" },
		writebuttons: { check: "Array" }
	},
	
	construct: function () {
		this.base(arguments);
		//this.setBorder(new qx.renderer.border.Border(1, "solid", "#91A5BD"));
		this.setMinHeight("auto");
		this.setButtons( {} );
		this.setWritebuttons( [] );
	},
	
	members:
	{
		add_button: function(label, icon, read_only, execute, _this){
			var b = new qx.ui.toolbar.Button(label, "icon/16/"+icon+".png");
			
			b.addEventListener("execute", execute, _this);
			b.setToolTip(new qx.ui.popup.ToolTip(label));
			b.setShow("icon");
			
			this.add(b);
			this.getButtons()[label] = b;
			if (!read_only) { this.getWritebuttons().push(b); }
		},
		
		set_read_only_mode: function(mode) {
			var b = this.getWritebuttons();
			
			for ( var i in b ) {
				b[i].setEnabled(!mode);
			}
		}
	}
});
