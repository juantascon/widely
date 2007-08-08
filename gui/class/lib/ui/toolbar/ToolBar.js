/*
 * Define metodos y atributos de un toolbar (barra de herramientas)
 *
 */
qx.Mixin.define("lib.ui.toolbar.ToolBar",
{
	properties:
	{
		// La lista de todos los botones
		buttons: { check: "Object" },
		// La lista de los botones que tienen modo permanente
		permanentbuttons: { check: "Array" },
		// El tamaño de todos los iconos del toolbar
		iconsize: { check: "Number" }
	},
	
	members:
	{
		/*
		 * Inicia las propiedades del toolbar
		 *
		 * iconsize: el tamaño de todos los iconos del toolbar
		 */
		initialize_toolbar: function(iconsize) {
			this.setIconsize(iconsize);
			this.setButtons( {} );
			this.setPermanentbuttons( [] );
		},
		
		/*
		 * Crea un boton con un tooltip y lo añade a la lista de botones
		 * del toolbar
		 *
		 * label: la etiqueta del boton
		 * icon: el icono del boton
		 * permanent: si es true adicionalemente lo añade a la lista de botones permanentes
		 * execute: la funcion a ajecutar en caso de que se haga click en el boton
		 * _this: el objeto this de la ejecucion del metodo execute
		 */
		create_button: function(label, icon, permanent, execute, _this) {
			var b = new qx.ui.toolbar.Button(label, "icon/"+this.getIconsize()+"/"+icon+".png");
			b.set({height: "auto", width: "auto"});
			//b.setBorder("outset");
			
			b.addEventListener("execute", execute, _this);
			b.setToolTip(new qx.ui.popup.ToolTip(label));
			b.setShow("icon");
			
			this.getButtons()[label] = b;
			if (permanent) { this.getPermanentbuttons().push(b); }
			
			return b;
		},
		
		/*
		 * Crea el boton y lo adiciona al toolbar
		 *
		 * label: la etiqueta del boton
		 * icon: el icono del boton
		 * permanent: si es true adicionalemente lo añade a la lista de botones permanentes
		 * execute: la funcion a ajecutar en caso de que se haga click en el boton
		 * _this: el objeto this de la ejecucion del metodo execute
		 */
		add_button: function(label, icon, permanent, execute, _this) {
			var b = this.create_button(label, icon, permanent, execute, _this);
			this.add(b);
		},
		
		/*
		 * Coloca o quita la propiedad solo lectura del toolbar
		 * (Des)Activando todos los botones excepto los permanentes
		 *
		 * mode: si debe estar en modo solo lectura
		 *
		 */
		set_mode_ro: function(mode) {
			this.set_mode_disable(mode);
			
			if (mode) {
				var b = this.getPermanentbuttons();
				
				for ( var i in b ) {
					b[i].setEnabled(true);
				}
			}
		},
		
		/*
		 * Coloca o quita la propiedad deshabilitado del toolbar
		 * (Des)Activando todos los botones
		 *
		 * mode: si debe estar en modo deshabilitado
		 *
		 */
		set_mode_disable: function(mode) {
			var b = this.getButtons();
			
			for ( var i in b ) {
				b[i].setEnabled(!mode);
			}
		}
	}
});
