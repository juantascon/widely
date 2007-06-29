qx.Class.define("ide.editor.TabView",
{
	extend: qx.ui.pageview.tabview.TabView,
	
	construct: function () {
		this.base(arguments, "vertical");
		
		this.set({height: "1*", width: "100%"});
		
		this.getBar().getManager().addEventListener("changeSelected", function(e) {
			
			var b = e.getValue();
			this.debug(this.getTabs().length());
			
			for (var i = 0; i < this.getTabs().length(); i++){
				if (this.getTabs().get(i).getButton() == b){
					this.setSelected(this.getTabs().get(i));
					break;
				}
			}
			
			var read_only = this.getSelected().getFile().is_read_only()
			global.editorview.getToolbar().set_read_only_mode(read_only);
			
		}, this);
	},
	
	properties:
	{
		tabs: { check: "lib.lang.List", init: new lib.lang.List() },
		selected: { check: "ide.editor.Tab" }
	},
	
	members:
	{
		add_tab: function(file){
			for (var i = 0; i < this.getTabs().length(); i++){
				var tab = this.getTabs().get(i);
				
				if (tab.getFile().getPath() == file.getPath() &&
					tab.getFile().getVersion() == file.getVersion()) {
					
					tab.getButton().setChecked(true);
					return tab;
				}
			}
			
			var tab = new ide.editor.Tab(file);
			
			this.getBar().add(tab.getButton());
			this.getPane().add(tab.getPage());
			
			tab.getButton().addEventListener("closetab", function(e) {
				var b = e.getData();
				var tabs = this.getTabs();
				
				if (tabs.length() <= 1){
					return;
				}
				for (var i = 0; i < tabs.length(); i++) {
					if (tabs.get(i).getButton() == b) {
						tabs.get(i).dispose();
						tabs.remove(i).getButton().setChecked(true);
						break;
					}
				}
			}, this);
			
			this.getTabs().add(tab);
			tab.getButton().setChecked(true);
			
			return tab;
		}
	}
});
