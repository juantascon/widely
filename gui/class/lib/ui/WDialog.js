qx.Class.define("lib.ui.WDialog",
{
	extend: qx.ui.window.Window,
	
	events:
	{
		"ok": "qx.event.type.Event",
		"cancel": "qx.event.type.Event"
	},
	
	properties:
	{
		OK: { check: "qx.ui.form.Button" },
		CANCEL: { check: "qx.ui.form.Button" },
		content: { check: "qx.ui.core.Widget" },
		pmodal: { check: "qx.ui.core.Widget" }
	},
	
	construct: function (pmodal, title, content) {
		this.base(arguments, title, "icon/16/actions/system-run.png");
		
		with(this) {
			setPmodal(pmodal);
			setContent(content);
			
			setOK(new qx.ui.form.Button("OK", "icon/16/actions/dialog-ok.png"));
			getOK().addEventListener("execute", function(e) {
				this.createDispatchEvent("ok");
				this.stop();
			}, this);
		
			setCANCEL(new qx.ui.form.Button("Cancel", "icon/16/actions/dialog-cancel.png"));
			getCANCEL().addEventListener("execute", function(e) {
				this.createDispatchEvent("cancel");
				this.stop();
			}, this);
			
			setModal(true);
			setMoveable(false);
			set({ showClose: false, showMaximize: false, showMinimize: false });
			set({height: "auto", width: "auto"});
		}
		
		this.addEventListener("appear", function(e) {
			this.centerToBrowser();
		}, this);
		
		var buttons = new qx.ui.layout.HorizontalBoxLayout();
		with(buttons) {
			setEdge(0);
			setSpacing(15);
			set({height: "1*", width: "100%"});
			
			setVerticalChildrenAlign("middle");
			setHorizontalChildrenAlign("center");
			
			add(this.getOK());
			add(this.getCANCEL());
		}
		
		var frame = new qx.ui.layout.VerticalBoxLayout();
		with(frame) {
			setEdge(10, 10, 10, 10);
			setSpacing(15);
			set({height: "100%", width: "100%"});
			setVerticalChildrenAlign("middle");
			setHorizontalChildrenAlign("center");
		}
		
		frame.add(content);
		frame.add(buttons);
		
		this.add(frame);
		this.start();
	},
	
	members:
	{
		start: function() {
			with(this) {
				addToDocument();
				getPmodal().setEnabled(false);
				open();
			}
		},
		
		stop: function() {
			with(this) {
				close();
				getPmodal().setEnabled(true);
				dispose();
			}
		}
	}
});
