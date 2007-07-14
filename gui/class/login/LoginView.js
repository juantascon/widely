qx.Class.define("login.LoginView",
{
	extend: qx.ui.layout.CanvasLayout,
	
	properties:
	{
		panel: { check: "qx.ui.layout.VerticalBoxLayout" },
		username: { check: "qx.ui.form.TextField" },
		password: { check: "qx.ui.form.PasswordField" },
		loginbutton: { check: "login.LoginButton" }
	},
	
	construct: function() {
		this.base(arguments);
		with(this) {
			setBorder("outset");
			set({ maxWidth: "auto", maxHeight: "auto" });
			set({minWidth: "auto", minHeight: "auto"});
			set({width: "auto", height: "auto"});
			setPadding(20);
		}
		
		this.setPanel(new qx.ui.layout.VerticalBoxLayout);
		with (this.getPanel()) {
			set({ left: 0, top: 0, width: "auto", height: "auto" });
			setSpacing(4);
		}
		
		this.setUsername(new qx.ui.form.TextField(""));
		this.setPassword(new qx.ui.form.PasswordField(""));
		
		var spacer = new qx.ui.basic.VerticalSpacer()
		spacer.setHeight(5);
		
		this.setLoginbutton(
			new login.LoginButton(this.getUsername(),
			this.getPassword()));
		
		with(this.getPanel()) {
			add(this.label_field("User", "apps/system-users", this.getUsername()));
			add(this.label_field("Password", "actions/encrypt", this.getPassword()));
			add(spacer);
			add(this.getLoginbutton());
		}
		
		this.add(this.getPanel());
	},
	
	members:
	{
		label_field: function(label, icon, field) {
			var box = new  qx.ui.layout.HorizontalBoxLayout
			with(box) {
				set({ left: 0, width: "100%", height: "auto" });
				setVerticalChildrenAlign("middle");
				setSpacing(10);
			}
			
			var atom = new qx.ui.basic.Atom(label, "icon/22/"+icon+".png");
			with(atom) {
				set({ left: 0, width: "40%" });
				setHorizontalChildrenAlign("left");
				setSpacing(7);
			}
			
			field.set({ right: 0, width: "60%" });
			
			box.add(atom, field);
			return box;
		},
		
		center_on_grid: function(){
			var grid = new qx.ui.layout.GridLayout();
			with(grid) {
				set({width: "40%"});
				
				setColumnCount(3);
				setColumnWidth(0, "20%");
				setColumnWidth(1, "60%");
				setColumnWidth(2, "20%");
				
				setRowCount(3);
				setRowHeight(0, "20%");
				setRowHeight(1, "60%");
				setRowHeight(2, "20%");
				
				add(this, 1, 1);
			}
			
			return grid;
		}
	},
	
	settings : {"login.resourceUri" : "./resource" }
});
