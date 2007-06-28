qx.Class.define("lib.ui.Dialog",
{
	extend: qx.ui.window.Window,
	
	construct: function (title, message, content) {
		this.base(arguments, title, "icon/16/actions/system-run.png");
		with(this) {
			setModal(true);
			setShowClose(false);
			setShowMaximize(false);
			setShowMinimize(false);
			setMoveMethod("translucent");
			set({height: "auto", width: "auto"});
		}
		
		this.setOK(new qx.ui.form.Button("OK", "icon/16/actions/dialog-ok.png"));
		this.setCANCEL(new qx.ui.form.Button("Cancel", "icon/16/actions/dialog-cancel.png"));
		
		this.getOK().addEventListener("execute", function(e) {
			this.createDispatchEvent("ok");
			this.stop();
		}, this);
		this.getCANCEL().addEventListener("execute", function(e) {
			this.createDispatchEvent("cancel");
			this.stop();
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
		
		frame.add(new qx.ui.basic.Atom(message));
		if (content) { frame.add(content); }
		frame.add(buttons);
		
		this.add(frame);
		this.start();
	},
	
	properties:
	{
		OK: { check: "qx.ui.form.Button" },
		CANCEL: { check: "qx.ui.form.Button" }
	},
	
	members:
	{
		start: function() {
			this.open();
			this.addToDocument();
		},
		
		stop: function() {
			this.close();
			this.dispose();
		}
	},
	
	events: {
		"ok": "qx.event.type.Event",
		"cancel": "qx.event.type.Event"
	}
});
