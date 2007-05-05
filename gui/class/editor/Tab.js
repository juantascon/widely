qx.Class.define("editor.Tab",
{
	extend: qx.core.Object,
	construct: function (file) {
		qx.core.Object.call(this);
		
		this.setFile(file);
		
		var textarea = new qx.ui.form.TextArea("");
		
		textarea.set({heights: "100%", widths: "100%"});
		
		textarea.addEventListener("keypress", function(e){
			if (e.getKeyIdentifier() == "Tab"){
				var text = textarea.getComputedValue();
				var position = textarea.getSelectionStart();
				
				textarea.setValue(
					text.substr(0,position) +
					"\t" +
					text.substr(position, text.length)
				);
				
				textarea.setSelectionStart(position+1);
				textarea.setSelectionLength(0);
				e.stopPropagation();
			}
		});
		
		this.setButton(new qx.ui.pageview.tabview.Button(this.getFile().getName()));
		with(this.getButton()) {
			setChecked(true);
			setShowCloseButton(true);
		}
		
		this.setPage(new qx.ui.pageview.tabview.Page(this.getButton()));
		this.getPage().add(textarea);
		
		this.getFile().setTextarea(textarea);
		this.getFile().load();
	},
	
	members:
	{
		dispose: function() {
			b = this.getButton();
			p = this.getPage();
			
			b.getParent().remove(b);
			p.getParent().remove(p);
			b.dispose();
			p.dispose();
		}
	},
	
	properties:
	{
		file: { check: "tree.File" },
		button: { check: "qx.ui.pageview.tabview.Button" },
		page: { check: "qx.ui.pageview.tabview.Page" }
	}
});
