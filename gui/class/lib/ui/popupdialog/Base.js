/*
 * Dialog en forma de popup con un contenido cualquiera
 * un boton para aceptar y se cancela al hacer click fuera de su area
 *
 */
qx.Class.define("lib.ui.popupdialog.Base",
{
	extend: qx.ui.popup.Popup,
	
	events:
	{
		// Cuando se presiona el boton OK
		"ok": "qx.event.type.Event",
		// Cuando se presiona fuera del dialogo
		"cancel": "qx.event.type.Event"
	},
	
	properties:
	{
		OK: { check: "qx.ui.form.Button" },
		frame: { check: "qx.ui.layout.HorizontalBoxLayout" },
		// El contenido del dialogo, puede ser un widget de cualquier tipo
		content: { check: "qx.ui.core.Widget" }
	},
	
	/*
	 * position_parent: para dibujar el dialogo en una posicion relativa a su padre
	 * content: el contenido del dialogo
	 */
	construct: function (position_parent, content) {
		this.base(arguments);
		
		this.setContent(content);
		this.setOK(new qx.ui.form.Button("OK", "icon/16/actions/dialog-ok.png"));
		
		this.getOK().addEventListener("execute", function(e) {
			this.createDispatchEvent("ok");
			this.stop();
		}, this);
		
		this.addEventListener("disappear", function(e) {
			/*
			 * si el dialogo aun no ha disparado el evento 
			 * hay que activar el evento cancel
			 */
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
			positionRelativeTo(position_parent);
			setBackgroundColor("white");
			setBorder(new qx.ui.core.Border(1, "solid", "#91A5BD"));
			
			add(this.getFrame());
			start();
		}
	},
	
	members:
	{
		/*
		 * flag que indica que el evento del dialogo
		 * ya ha sido disparado
		 */
		fired: false,
		
		/*
		 * Muestra el dialogo y lo adiciona al DOM
		 *
		 */
		start: function() {
			this.show();
			this.bringToFront();
			this.addToDocument();
		},
		/*
		 * Detiene el dialogo y marca el flag de que se disparo el
		 * evento asociado a lo que paso en el dialogo
		 *
		 */
		stop: function() {
			this.fired = true;
			this.hide();
			this.dispose();
		}
	}
});
