qx.Mixin.define("lib.form.Helper",
{
	members:
	{
		create_dialog: function(pmodal, title) {
			var d = new lib.ui.WDialog(pmodal, title, this);
			return d;
		},
		
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
		
		create_combobox: function(headers, wrq) {
			var c = new qx.ui.form.ComboBoxEx();
			
			with(c) {
				set({left: 0, top: 0, height: "auto", width: "auto"});
				var arr = qx.lang.Array.insertAt(qx.lang.Array.copy(headers), "ID", 0);
				for (var i in arr) {
					arr[i] = qx.lang.String.toFirstUp(arr[i]);
				}
				setColumnHeaders(arr);
			}
			
			wrq.addEventListener("ok", function(e) {
				var list = e.getData();
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
				
			}, this);
			
			return c;
		}
	}
});
