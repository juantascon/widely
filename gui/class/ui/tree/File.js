qx.Class.define("ui.tree.File",
{
	extend: qx.ui.tree.TreeFile,
	
	include: dao.File,
	
	construct: function (name, path) {
		qx.ui.tree.TreeFile.call(this, name);
		this.setName(name);
		this.setPath(path);
		
		this.addEventListener("click", function(e){
			ui.editor.EditorView.getInstance().getTabview().add_tab(this);
		}, this);
	},
	
	statics:
	{
		new_from_hash: function(h){
			return new ui.tree.File(h["text"], h["id"]);
		}
	}
});
