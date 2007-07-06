qx.Class.define("lib.ui.ToolBar",
{
	extend: qx.ui.layout.BoxLayout,
	
	properties:
	{
		buttons: { check: "Object" },
		permanentbuttons: { check: "Array" },
		iconsize: { check: "Number" }
	},
	
	construct: function(orientation, iconsize) {
		this.base(arguments, orientation);
		
		this.setIconsize(iconsize);
		this.setButtons( {} );
		this.setPermanentbuttons( [] );
		
		this.set({left: 0, top: 0});
		if (this.getOrientation() == "vertical") { this.set({height: null, width: "auto"}); }
		if (this.getOrientation() == "horizontal") { this.set({height: "auto", width: null}); }
	},
	
	members:
	{
		add_button: function(label, icon, permanent, execute, _this){
			var b = new qx.ui.toolbar.Button(label, "icon/"+this.getIconsize()+"/"+icon+".png");
			b.set({height: "auto", width: "auto"});
			b.setBorder("outset");
			
			b.addEventListener("execute", execute, _this);
			b.setToolTip(new qx.ui.popup.ToolTip(label));
			b.setShow("icon");
			
			this.add(b);
			this.getButtons()[label] = b;
			if (permanent) { this.getPermanentbuttons().push(b); }
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
