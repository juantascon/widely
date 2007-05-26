qx.Class.define("ui.editor.Tab",
{
	extend: qx.core.Object,
	
	construct: function (file) {
		this.base(arguments);
		
		this.setFile(file);
		var f = this.getFile()
		
		this.setVersion(f.getTree().getVersion());
		
		var label = f.getName();
		if (f.getTree().is_read_only()) { label += " :: ["+f.getTree().getVersion()+"]"; }
		
		this.setButton(new qx.ui.pageview.tabview.Button(label));
		with(this.getButton()) {
			setChecked(true);
			setShowCloseButton(true);
		}
		
		this.setPage(new qx.ui.pageview.tabview.Page(this.getButton()));
		this.getPage().add(this.getFile().getTextarea());
		
		this.getFile().dao_load();
	},
	
	properties:
	{
		file: { check: "ui.selector.File" },
		button: { check: "qx.ui.pageview.tabview.Button" },
		page: { check: "qx.ui.pageview.tabview.Page" },
		version: { check: "Number", init: core.Cons.WC }
	},
	
	members:
	{
		dispose: function() {
			b = this.getButton();
			p = this.getPage();
			
			b.getManager().remove(b);
			b.getParent().remove(b);
			p.getParent().remove(p);
			
			b.dispose();
			p.dispose();
			
			this.getFile().setTextarea(this.getFile().create_textarea());
			
		}
	}
});
