qx.Class.define("editor.Tab",
{
	extend: qx.core.Object,
	construct: function (file) {
		var _this = this;
		qx.core.Object.call(this);
		
		this.file = file;
		
		this.button = new qx.ui.pageview.tabview.Button(file.getName());
		this.button.setChecked(true);
		this.button.setShowCloseButton(true);
		
		this.area = new qx.ui.form.TextArea(file.content);
		with(this.area) {
			setHeight("100%");
			setWidth("100%");
			setOverflow("scrollY");
			
			this.area.addEventListener("appear", function(e){
				_this.area.set({left: 0, right: 0, top: 0, bottom: 0});
			});
			
			addEventListener("keypress", function(e){
				if (e.getKeyIdentifier() == "Tab"){
					var text = _this.area.getComputedValue();
					var position = _this.area.getSelectionStart();
					
					_this.area.setValue(text.substr(0,position) + "\t" + text.substr(position, text.length));
					_this.area.setSelectionStart(position+1);
					_this.area.setSelectionLength(0);
					e.stopPropagation();
				}
			});
		}
		
		
		this.file.load_content(this.area);
		
		this.page = new qx.ui.pageview.tabview.Page(this.button);
		this.page.add(this.area);
	},
	
	members:
	{
		file: null,
		button: null,
		page: null,
		area: null
	}
});
