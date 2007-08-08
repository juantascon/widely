/*
 * Funcionalidad grafica de mover copiar y renombrar un archivo
 *
 */
qx.Mixin.define("ide.selector.fs.DragAndDrop",
{
	include: ide.selector.fs.Object,
	
	members:
	{
		/*
		 * El objeto puede moverse/copiarse
		 *
		 */
		set_fs_dragable: function() {
			var drag_drop_handler = qx.event.handler.DragAndDropHandler.getInstance();
			
			this.addEventListener("dragstart", function(e) {
				//this.debug("dragstart");
				e.addData("qx.ui.tree.AbstractTreeElement", e.getCurrentTarget());
				
				e.addAction("move");
				e.addAction("copy");
				
				e.startDrag();
			}, this);
		},
		
		/*
		 * El objeto puede recibir archivos/directorios para que estos
		 * se muevan
		 *
		 */
		set_fs_dropable: function() {
			this.addEventListener("dragdrop", function(e) {
				//this.debug("dragdrop");
				var type = e.getDropDataTypes()[0];
				var source = e.getData(type);
				var target = e.getCurrentTarget();
				
				source.getTree().getManager().deselectAll();
				
				/*
				 * Si se llega a este punto se deben mover o copiar los archivos en el FS
				 *
				 */
				var action = e.getAction();
				var mv_rq = this.wc_move(source.full_name(), target.full_name());
				
				mv_rq.addEventListener("ok", function(e) {
					
					// Se mueve el objeto
					if (action == "move") {
						source.setPath(target.full_name());
						target.add(source);
					}
					
					// Se copia el objeto
					if (action == "copy") {
						// TODO: buscar como clonar un objeto
						var clone = source.clone();
						clone.setPath(target.full_name());
						target.add(clone);
					}
					
				}, this);
				
				mv_rq.addEventListener("fail", function(e) {
					lib.ui.Msg.error(source, "imposible to move, try with commit first");
				}, this);
				
				e.stopPropagation();
			}, this);
			
			// Coloca la decoracion cuando el cursor pasa por encima
			this.addEventListener("dragover", function(e) {
				//this.debug("dragover");
				var l = e.getTarget().getLabelObject();
				l.setStyleProperty("textDecoration", "underline");
			}, this);
			
			// Quita la decoracion cuando el click se suelta
			this.addEventListener("dragout", function(e) {
				//this.debug("dragout");
				var l = e.getTarget().getLabelObject();
				l.removeStyleProperty("textDecoration");
			}, this);
			
			this.supportsDrop = function (vDragCache) {
				return !vDragCache.sourceWidget.contains(this);
			};
			
			this.setDropDataTypes(["qx.ui.tree.AbstractTreeElement"]);
		},
		
		/*
		 * Activa la operacion de renombrar el objeto con doble click
		 *
		 */
		set_fs_renameable: function() {
			this.addEventListener("dblclick", function(e) {
				// Se pregunta el nuevo nombre del objeto
				var dialog = new lib.ui.popupdialog.Input(this, this.getName());
				
				dialog.addEventListener("ok", function(e) {
					
					var text = dialog.get_text();
					
					var mv_rq = this.wc_move(
						this.getPath()+"/"+this.getName(),
						this.getPath()+"/"+text);
					
					mv_rq.addEventListener("ok", function(e) {
						this.setName(text);
						this.setLabel(text);
					}, this);
					
					mv_rq.addEventListener("fail", function(e) {
						lib.ui.Msg.error(this, "imposible to rename, try with commit first");
					}, this);
					
				}, this);
				
				e.stopPropagation();
			}, this);
		}
	}
});
