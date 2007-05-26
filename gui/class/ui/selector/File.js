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
			core.Obj.editor.getTabview().add_tab(this);
		}, this);
		
		/* TODO: terminar el drag and drop de mover y copiar archivos
		function printEvent(e) {
			return "TARGET:" + (e.getTarget() ? e.getTarget().toHashCode() : "null") + " [ORIG:" + (e.getOriginalTarget() ? e.getOriginalTarget().toHashCode() : "null") + "]  [REL:" + (e.getRelatedTarget() ? e.getRelatedTarget().toHashCode() : "null") + "]";
		};
		
		this.addEventListener("dragstart", function(e){
			var feedbackWidget = new qx.ui.basic.Atom("Some HTML", "icon/16/file-new.png");
			feedbackWidget.set({ border:new qx.renderer.border.Border(1, "dashed", "gray"), opacity:0.7 });
			feedbackWidget.setPadding(2);
			
			e.setFeedbackWidget(feedbackWidget, 15, 0, true);
			//e.setCursorPosition(15, 25);
			this.debug("Fire DragStart: " + printEvent(e));
		});
		
		this.addEventListener("dragend", function(e){
			this.debug("Fire DragEnd: " + printEvent(e));
		});*/
	},
	
	members:
	{
		create_textarea: function() {
			var textarea = new qx.ui.form.TextArea("");
			
			textarea.set({height: "100%", width: "100%"});
			
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
