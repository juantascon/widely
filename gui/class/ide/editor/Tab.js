qx.Class.define("ide.editor.Tab",
{
	extend: qx.core.Object,
	
	include: lib.dao.WC,
	
	properties:
	{
		file: { check: "ide.selector.File" },
		button: { check: "qx.ui.pageview.tabview.Button" },
		page: { check: "qx.ui.pageview.tabview.Page" },
		textarea: { check: "qx.ui.form.TextArea" }
	},
	
	construct: function (file) {
		this.base(arguments);
		
		this.setFile(file);
		
		var label = this.getFile().getName();
		if (this.getFile().is_read_only()) { label += " :: ["+this.getFile().getVersion()+"]"; }
		
		this.setButton(new qx.ui.pageview.tabview.Button(label));
		with(this.getButton()) {
			setShowCloseButton(true);
		}
		
		this.initialize_textarea();
		
		this.setPage(new qx.ui.pageview.tabview.Page(this.getButton()));
		this.getPage().add(this.getTextarea());
		
		this.load_file_content();
	},
	
	members:
	{
		load_file_content: function() {
			var rq = this.wc_cat(this.getFile().full_name(), this.getFile().getVersion());
			rq.addEventListener("ok", function(e) {
				this.getTextarea().setValue(""+e.getData());
			}, this);
		},
		
		save_file_content: function() {
			var rq = this.wc_write(this.getFile().full_name(), this.getTextarea().getComputedValue());
		},
		
		initialize_textarea: function() {
			var textarea = new qx.ui.form.TextArea("");
			textarea.set({height: "100%", width: "100%"});
			
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
					e.preventDefault();
					e.stopPropagation();
				}
			});
			
			textarea.addEventListener("insertDom", function(e) {
				var read_only = this.getFile().is_read_only();
				this.getTextarea().setReadOnly(read_only);
			}, this);
			
			this.setTextarea(textarea);
		},
		
		dispose: function() {
			b = this.getButton();
			p = this.getPage();
			
			b.getManager().remove(b);
			b.getParent().remove(b);
			p.getParent().remove(p);
			
			b.dispose();
			p.dispose();
			
			this.initialize_textarea();
		}
	}
});
