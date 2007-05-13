qx.Class.define("ui.component.WCDirDialog",
{
	extend: ui.component.Dialog,
	
	construct: function (title, message) {
		this.setTree(new ui.selector.FileTree());
		
		this.getTree().set({height: 300, width: 200});
		this.getTree().setOverflow("scroll");
		
		this.getTree().load_from_hash = function(data) {
			for (var i in data) {
				if (data[i]["type"] == "dir"){
					this.getTree().addToFolder(ui.selector.Dir.new_from_hash(data[i], true));
				}
			}
		};
		
		this.getTree().load();
		this.base(arguments, title, message, this.getTree());
	},
	
	properties:
	{
		tree: { check: "ui.selector.FileTree" }
	},
	
	members:
	{
		
		selected_dir: function() {
			return this.getTree().getSelectedElement();
		}
	}
});
