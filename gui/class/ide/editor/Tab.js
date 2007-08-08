/*
 * Define un tab que representa la edicion de un archivo
 *
 */
qx.Class.define("ide.editor.Tab",
{
	extend: lib.ui.PageViewTab,
	
	include: lib.dao.api.WC,
	
	properties:
	{
		// El archivo que se esta editando
		file: { check: "ide.selector.fs.File" },
		
		// El area de texto encargada de editar el archivo
		textarea: { check: "qx.ui.form.TextArea" }
	},
	
	/*
	 * file: el archivo para crear el tab
	 *
	 */
	construct: function (file) {
		this.setFile(file);
		
		var label = this.getFile().getName();
		if (this.getFile().is_read_only()) {
			label += " :: ["+this.getFile().getVersion()+"]";
		}
		
		this.base(arguments, "tabview", label);
		
		this.initialize_textarea();
		this.getPage().add(this.getTextarea());
		
		this.getButton().setShowCloseButton(true);
		
		this.load_file_content();
	},
	
	members:
	{
		/*
		 * Carga el contenido del archivo y lo muestra en el area
		 * de edicion de texto
		 *
		 */
		load_file_content: function() {
			var rq = this.wc_cat(this.getFile().full_name(), this.getFile().getVersion());
			rq.addEventListener("ok", function(e) {
				this.getTextarea().setValue(""+e.getData());
			}, this);
		},
		
		/*
		 * Almacena en el servidor el nuevo contenido del archivo
		 *
		 */
		save_file_content: function() {
			var rq = this.wc_write(this.getFile().full_name(), this.getTextarea().getComputedValue());
		},
		
		/*
		 * Crea un area de texto nueva quitando la anterior en caso de que
		 * exista
		 *
		 */
		initialize_textarea: function() {
			var textarea = new qx.ui.form.TextArea("");
			textarea.set({height: "100%", width: "100%"});
			
			/*
			 * Cuando se presiona la tecla tab debe imprimirse el caracter tabulador
			 * en lugar de cambiar de seleccion
			 *
			 */
			textarea.addEventListener("keypress", function(e){
				if (e.getKeyIdentifier() == "Tab"){
					var text = textarea.getComputedValue();
					// La posicion de edicion del area de texto
					var position = textarea.getSelectionStart();
					
					/*
					 * Agrega el caracter tab en la posicion de edicion
					 * del area de texto
					 *
					 */
					textarea.setValue(
						text.substr(0,position) +
						"\t" +
						text.substr(position, text.length)
					);
					
					/*
					 * Vuelve a colocar la posicion de edicion del area de
					 * texto
					 *
					 */
					textarea.setSelectionStart(position+1);
					textarea.setSelectionLength(0);
					
					// Previene que el evento siga su curso normal
					e.preventDefault();
					
					//Detiene la propagacion del evento
					e.stopPropagation();
				}
			});
			
			/*
			 * Cuando el area de texto es insertada en el DOM se coloca
			 * en modo solo lectura en caso de que el archivo sea de solo
			 * lectura
			 *
			 */
			textarea.addEventListener("insertDom", function(e) {
				var read_only = this.getFile().is_read_only();
				this.getTextarea().setReadOnly(read_only);
			}, this);
			
			this.setTextarea(textarea);
		},
		
		/*
		 * Elimina el tab
		 *
		 */
		dispose: function() {
			b = this.getButton();
			p = this.getPage();
			
			b.getManager().remove(b);
			b.getParent().remove(b);
			p.getParent().remove(p);
			
			b.dispose();
			p.dispose();
			
			this.initialize_textarea();
		}
	}
});
