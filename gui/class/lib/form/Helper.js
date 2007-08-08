/*
 * Metodos de ayuda para las Formas
 *
 */
qx.Mixin.define("lib.form.Helper",
{
	members:
	{
		/*
		 * Crea un dialogo con la forma incluida en el
		 *
		 * pmodal: el padre del dialogo
		 * title: el titulo del dialogo
		 *
		 */
		create_dialog: function(pmodal, title) {
			var d = new lib.ui.WDialog(pmodal, title, this);
			return d;
		},
		
		/*
		 * Crea una grilla con etiquetas a un lado y campos de
		 * entrada en el otro lado
		 *
		 * labels: un array con la lista de etiquetas de los campos de entrada
		 * inputs: los campos de entrada
		 * h: la altura de la grilla
		 * w: el ancho de la grilla
		 *
		 */
		create_grid: function(labels, inputs, h, w) {
			var grid = new qx.ui.layout.GridLayout();
			with(grid) {
				set({left: 0, top: 0, height: h, width: w});
				
				setColumnCount(2);
				setColumnWidth(0, "40%");
				setColumnWidth(1, "60%");
				
				setRowCount(labels.length);
				for (var i in labels) {
					setRowHeight(i, ""+parseInt(100/labels.length)+"%");
					add(new qx.ui.basic.Label(labels[i]), 0, i);
				}
				
				for (var i in inputs) {
					add(inputs[i], 1, i);
				}
			}
			
			return grid;
		},
		
		/*
		 * Crea una lista de valores (ComboBoxEx)
		 *
		 * headers: Las cabezeras de la lista de valores
		 * wrq: la peticion para cargar los valores de la lista
		 *
		 */
		create_combobox: function(headers, wrq) {
			var c = new qx.ui.form.ComboBoxEx();
			
			/*
			 * Coloca la primer letra de cada cabezera
			 * en mayuscula
			 *
			 */
			with(c) {
				set({left: 0, top: 0, height: "auto", width: "auto"});
				var arr = qx.lang.Array.insertAt(qx.lang.Array.copy(headers), "ID", 0);
				for (var i in arr) {
					arr[i] = qx.lang.String.toFirstUp(arr[i]);
				}
				setColumnHeaders(arr);
			}
			
			wrq.addEventListener("ok", function(e) {
				// La lista obtenida de la peticion
				var list = e.getData();
				/*
				 * Si la lista tiene elementos entonces se deben agregar en
				 * la lista de valores y colocar el primer valor como el
				 * valor seleccionado por defecto en la lista de valores
				 *
				 */
				if (list.length > 0) {
					// Los elementos para la lista de valores
					var selection = [];
					
					for(var i in list) {
						var item = [];
						item.push(i);
						
						for (var h in headers) {
							item.push(list[i][headers[h]]);
						}
						
						selection.push(item);
					}
					
					c.setSelection(selection);
					c.setSelectedIndex(0);
				}
			}, this);
			
			return c;
		}
	}
});
