qx.Class.define("lib.ui.dialogpopup.Base",
{
	extend: qx.ui.popup.Popup,
	
	events:
	{
		"ok": "qx.event.type.Event",
		"cancel": "qx.event.type.Event"
	},
	
	properties:
	{
		OK: { check: "qx.ui.form.Button" },
		frame: { check: "qx.ui.layout.HorizontalBoxLayout" },
		content: { check: "qx.ui.core.Widget" }
	},
	
	construct: function (parent, content) {
		this.base(arguments);
		
		this.setContent(content);
		this.setOK(new qx.ui.form.Button("OK", "icon/16/actions/dialog-ok.png"));
		
		this.getOK().addEventListener("execute", function(e) {
			this.createDispatchEvent("ok");
			this.stop();
		}, this);
		
		this.addEventListener("disappear", function(e) {
			if ( ! this.fired ) { this.createDispatchEvent("cancel"); }
			this.stop();
		});
		
		this.setFrame(new qx.ui.layout.HorizontalBoxLayout());
		with(this.getFrame()) {
			setEdge(5, 5, 5, 5);
			setSpacing(5);
			set({height: "auto", width: "auto"});
			
			setVerticalChildrenAlign("middle");
			setHorizontalChildrenAlign("center");
			
			add(this.getContent());
			add(this.getOK());
		}
		
		with(this) {
			set({height: "auto", width: "auto"});
			setAutoHide(true);
			positionRelativeTo(parent);
			setBackgroundColor("white");
			setBorder(new qx.ui.core.Border(1, "solid", "#91A5BD"));
			
			add(this.getFrame());
			start();
		}
	},
	
	members:
	{
		fired: false,
		
		start: function() {
			this.show();
			this.bringToFront();
			this.addToDocument();
		},
		
		stop: function() {
			this.fired = true;
			this.hide();
			this.dispose();
		}
	}
});
