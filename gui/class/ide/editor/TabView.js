qx.Class.define("ide.editor.TabView",
{
	extend: qx.ui.pageview.tabview.TabView,
	
	properties:
	{
		tabs: { check: "lib.lang.List", init: new lib.lang.List() },
		selected: { check: "ide.editor.Tab" }
	},
	
	construct: function () {
		this.base(arguments, "vertical");
		
		this.set({height: "1*", width: "100%"});
		
		this.getBar().getManager().addEventListener("changeSelected", function(e) {
			var b = e.getValue();
			
			for (var i = 0; i < this.getTabs().size(); i++){
				if (this.getTabs().get_at(i).getButton() == b){
					this.setSelected(this.getTabs().get_at(i));
					break;
				}
			}
			
			var read_only = this.getSelected().getFile().is_read_only()
			global.editorview.getToolbar().set_mode_ro(read_only);
		}, this);
	},
	
	members:
	{
		add_tab: function(file){
			for (var i = 0; i < this.getTabs().size(); i++ ){
				var tab = this.getTabs().get_at(i);
				
				if (tab.getFile().full_name() == file.full_name() &&
					tab.getFile().getVersion() == file.getVersion()) {
					this.debug(file.get("name"));
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
				
				for (var i = 0; i < tabs.size(); i++) {
					if (tabs.get_at(i).getButton() == b) {
						tabs.get_at(i).dispose();
						var next_tab = tabs.remove(i);
						if ( qx.util.Validation.isValid(next_tab) ) {
							next_tab.getButton().setChecked(true);
						}
						else {
							global.editorview.getToolbar().set_mode_disable(true);
						}
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
