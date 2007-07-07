qx.Mixin.define("ide.selector.FSDragAndDrop",
{
	
	includes: [ ide.selector.FSObject ],
	
	members:
	{
		set_fs_dragable: function() {
			var drag_drop_handler = qx.event.handler.DragAndDropHandler.getInstance();
			
			this.addEventListener("dragstart", function(e) {
				this.debug("dragstart");
				e.addData("qx.ui.tree.AbstractTreeElement", e.getCurrentTarget());
				e.addAction("move");
				e.startDrag();
			}, this);
		},
		
		set_fs_dropable: function() {
			this.addEventListener("dragdrop", function(e) {
				this.debug("dragdrop");
				var type = e.getDropDataTypes()[0];
				var source = e.getData(type);
				var target = e.getCurrentTarget();
				
				source.getTree().getManager().deselectAll();
				target.add(source);
				
				/*
				 * Si se llega a este punto se deben mover los archivos en el FS
				 *
				 */
				this.wc_move(source.full_name(), target.full_name());
				
				e.stopPropagation();
			}, this);
			
			this.addEventListener("dragover", function(e) {
				this.debug("dragover");
				var l = e.getTarget().getLabelObject();
				l.setStyleProperty("textDecoration", "underline");
			}, this);
			
			this.addEventListener("dragout", function(e) {
				this.debug("dragout");
				var l = e.getTarget().getLabelObject();
				l.removeStyleProperty("textDecoration");
			}, this);
			
			this.supportsDrop = function (vDragCache) {
				return !vDragCache.sourceWidget.contains(this);
			};
			
			this.setDropDataTypes(["qx.ui.tree.AbstractTreeElement"]);
		}
	}
});