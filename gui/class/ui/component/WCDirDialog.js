qx.Class.define("ui.component.WCDirDialog",
{
	extend: ui.component.Dialog,
	
	include: dao.Tree,
	
	construct: function (title, message) {
		this.setTree(new qx.ui.tree.Tree("WorkingCopy"));
		this.getTree().setSelectedElement(this.getTree().getParentFolder());
		with (this.getTree()) {
			set({height: 300, width: 200});
			setBackgroundColor(255);
			setOverflow("scroll");
			setBorder(new qx.renderer.border.Border(1, "solid", "#91A5BD"));
			
		}
		
		this.load();
		this.base(arguments, title, message, this.getTree());
	},
	
	properties:
	{
		tree: { check: "qx.ui.tree.Tree" }
	},
	
	members:
	{
		load_from_hash: function(data) {
			for (var i in data){
				if (data[i]["type"] == "dir"){
					this.getTree().addToFolder(ui.selector.Dir.new_from_hash(data[i], true));
				}
			}
		},
		
		selected_dir: function() {
			if (this.getTree().getSelectedElement() == this.getTree().getParentFolder() ||
				this.getTree().getSelectedElement() == this.getTree()) {
				return (new ui.selector.Dir("/", "/"));
			}
			
			return this.getTree().getSelectedElement();
		}
	}
});
