qx.Class.define("login.LoginView",
{
	extend : qx.ui.layout.CanvasLayout,
	
	include: lib.dao.Auth,
	
	properties:
	{
		username: { check: "qx.ui.form.TextField" },
		password: { check: "qx.ui.form.PasswordField" },
		loginbutton: { check: "qx.ui.basic.Atom" }
	},
	
	construct: function() {
		this.base(arguments);
		this.setBorder("outset");
		this.set({maxWidth: "auto", maxHeight: "auto"});
		this.set({minWidth: "auto", minHeight: "auto"});
		this.set({width: "auto", height: "auto"});
		this.setPadding(20);
		
		var panel = new qx.ui.layout.VerticalBoxLayout;
		with (panel) {
			set({ left: 0, top: 0, width: "auto", height: "auto" });
			setSpacing(4);
		}
		
		this.setUsername(new qx.ui.form.TextField(""));
		panel.add(this.label_field("User", "apps/system-users", this.getUsername()));
		
		this.setPassword(new qx.ui.form.PasswordField(""));
		panel.add(this.label_field("Password", "actions/encrypt", this.getPassword()));
		
		var spacer = new qx.ui.basic.VerticalSpacer()
		spacer.setHeight(5);
		panel.add(spacer);
		
		this.setLoginbutton(this.create_login_button());
		panel.add(this.getLoginbutton());
		
		this.add(panel);
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
		
		create_login_button: function() {
			var icon_login = "icon/32/actions/go-next.png";
			var icon_loading = "resource/loading.gif";
			var loading = false;
			
			var b = new qx.ui.basic.Atom("", icon_login);
			with(b) {
				setSpacing(4);
				setIconPosition("right");
				setHorizontalAlign("right");
			}
			
			b.addEventListener("click", function(e) {
				if ( loading ){ return; }
				
				loading = true;
				b.setIcon(icon_loading);
				
				var user = this.getUsername().getComputedValue();
				var password = this.getPassword().getComputedValue();
				
				var login_rq = this.auth_login(user, password);
				
				login_rq.addEventListener("fail", function(e) {
					loading = false;
					b.setIcon(icon_login);
					
					var t = new qx.ui.popup.ToolTip(
						"Invalid Login: <br/> Username/Password",
						"icon/64/status/dialog-error.png");
					with(t) {
						setAutoHide(false);
						setHideOnHover(false);
						positionRelativeTo(this.getUsername());
						
						addToDocument();
						bringToFront();
						show();
					}
				}, this);
				
				login_rq.addEventListener("ok", function(e) {
					setTimeout("window.location = \"./ide.html\"", 500);
				}, this);
			}, this);
			
			return b;
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