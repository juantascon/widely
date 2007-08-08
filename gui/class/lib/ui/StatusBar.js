/*
 * Una barra de estado para mostrar mensajes de informacion
 * sobre el estado de las peticiones al servidor
 *
 */

qx.Class.define("lib.ui.StatusBar",
{
	extend: qx.ui.layout.CanvasLayout,
	
	properties:
	{
		// El icono y el mensaje a mostrar
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
		/*
		 * Coloca un mensaje en la barra de estado
		 *
		 * text: el mensaje
		 * icon: un icono para mostrar con el texto
		 *
		 */
		log: function(text, icon){
			this.getAtom().setLabel(text);
			this.getAtom().setIcon("icon/16/"+icon+".png");
		},
		
		// Muestra un mensaje indicando que el proceso termino bien
		ok: function(text){ this.log(text, "actions/dialog-ok"); },
		// Muestra un mensaje indicando que el proceso termino mal
		fail: function(text){ this.log(text, "actions/dialog-no"); },
		// Muestra un mensaje indicando que el proceso esta en curso
		process: function(text){ this.log(text, "actions/go-next"); }
	}
});
