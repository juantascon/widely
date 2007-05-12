qx.Class.define("ui.StatusBar",
{
	type: "singleton",
	
	extend: qx.ui.layout.CanvasLayout,
	
	construct: function () {
		this.base(arguments);
		main.Obj.statusbar = this;
		
		this.setHeight("auto");
		this.setBorder(new qx.renderer.border.Border(1, "solid", "#91A5BD"));
		
		this.setAtom(new qx.ui.basic.Atom(""));
		this.getAtom().set({ minHeight: "auto", minWidth: "auto" });
		
		this.add(this.getAtom());
	},
	
	properties:
	{
		atom: { check: "qx.ui.basic.Atom" }
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
