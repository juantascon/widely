qx.Class.define("lib.ui.StatusBar",
{
	extend: qx.ui.layout.CanvasLayout,
	
	properties:
	{
		atom: { check: "qx.ui.basic.Atom" }
	},
	
	construct: function () {
		this.base(arguments);
		
		this.setHeight("auto");
		this.setBorder(new qx.ui.core.Border(1, "solid", "#91A5BD"));
		
		this.setAtom(new qx.ui.basic.Atom(""));
		this.getAtom().set({ minHeight: "auto", minWidth: "auto" });
		
		this.add(this.getAtom());
		this.ok("StatusBar: loaded");
	},
	
	members:
	{
		log: function(text, icon){
			this.getAtom().setLabel(text);
			this.getAtom().setIcon("icon/16/"+icon+".png");
		},
		
		ok: function(text){ this.log(text, "actions/dialog-ok"); },
		fail: function(text){ this.log(text, "actions/dialog-no"); },
		process: function(text){ this.log(text, "actions/go-next"); }
	}
});
