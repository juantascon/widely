qx.Mixin.define("lib.ui.toolbar.ToolBar",
{
	properties:
	{
		buttons: { check: "Object" },
		permanentbuttons: { check: "Array" },
		iconsize: { check: "Number" }
	},
	
	members:
	{
		initialize_toolbar: function(iconsize) {
			this.setIconsize(iconsize);
			this.setButtons( {} );
			this.setPermanentbuttons( [] );
		},
		
		create_button: function(label, icon, permanent, execute, _this) {
			var b = new qx.ui.toolbar.Button(label, "icon/"+this.getIconsize()+"/"+icon+".png");
			b.set({height: "auto", width: "auto"});
			//b.setBorder("outset");
			
			b.addEventListener("execute", execute, _this);
			b.setToolTip(new qx.ui.popup.ToolTip(label));
			b.setShow("icon");
			
			this.getButtons()[label] = b;
			if (permanent) { this.getPermanentbuttons().push(b); }
			
			return b;
		},
		
		add_button: function(label, icon, permanent, execute, _this) {
			var b = this.create_button(label, icon, permanent, execute, _this);
			this.add(b);
		},
		
		set_mode_ro: function(mode) {
			this.set_mode_disable(mode);
			
			if (mode) {
				var b = this.getPermanentbuttons();
				
				for ( var i in b ) {
					b[i].setEnabled(true);
				}
			}
		},
		
		set_mode_disable: function(mode) {
			var b = this.getButtons();
			
			for ( var i in b ) {
				b[i].setEnabled(!mode);
			}
		}
	}
});
