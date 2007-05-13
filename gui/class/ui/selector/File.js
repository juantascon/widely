qx.Class.define("ui.selector.File",
{
	extend: qx.ui.tree.TreeFile,
	
	include: dao.File,
	
	construct: function (name, path) {
		this.base(arguments, name);
		
		this.setName(name);
		this.setPath(path);
		
		this.setTextarea(this.create_textarea());
		
		this.addEventListener("click", function(e){
			main.Obj.editor.getTabview().add_tab(this);
		}, this);
	},
	
	members:
	{
		create_textarea: function() {
			var textarea = new qx.ui.form.TextArea("");
			textarea.set({heights: "100%", widths: "100%"});
			textarea.setReadOnly(false);
			
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
			
			textarea.addEventListener("insertDom", function(e) {
				if (this.getTree().is_read_only()) {
					this.getTextarea().setReadOnly(true);
				}
			}, this);
			
			return textarea;
		}
	},
	
	statics:
	{
		new_from_hash: function(h){
			return new ui.selector.File(h["text"], h["id"]);
		}
	}
});
