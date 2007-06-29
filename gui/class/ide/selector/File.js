qx.Class.define("ide.selector.File",
{
	extend: qx.ui.tree.TreeFile,
	
	include: [ lib.lang.Versioned, lib.dao.WC ],
	
	properties:
	{
		name: { check: "String", init: "" },
		path: { check: "String", init: ""}
	},
	
	construct: function (name, path, version) {
		this.base(arguments, name);
		this.debug("name: "+name + " path: "+path+" version: "+version);
		
		this.setName(name);
		this.setPath(path);
		this.setVersion(version);
		
		this.addEventListener("click", function(e){
			global.editorview.getTabview().add_tab(this);
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
	
	statics:
	{
		new_from_hash: function(h){
			return new ide.selector.File(h["text"], h["id"], h["version"]);
		}
	}
});
