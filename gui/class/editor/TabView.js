qx.Class.define("editor.TabView",
{
	extend: qx.ui.pageview.tabview.TabView,
	construct: function () {
		qx.ui.pageview.tabview.TabView.call(this, "vertical");
		this.set({left: 0, right: 0, top: 0, bottom: 0});
	},
	
	properties:
	{
		tabs: { check: "lang.List", init: new lang.List() }
	},
	
	members:
	{
		selected_tab: function(){
			var b = this.getBar().getManager().getSelected();
			for (var i = 0; i < this.getTabs.length(); i++){
				if (this.getTabs().get(i).button == b){
					return this.getTabs().get(i);
				}
			}
			return null;
		},
		
		add_tab: function(file){
			var _this = this;
			
			for (var i = 0; i < this.getTabs().length(); i++){
				if (this.getTabs().get(i).getFile() == file){
					this.getTabs().get(i).getButton().setChecked(true);
					return;
				}
			}
			
			var tab = new editor.Tab(file);
			this.getBar().add(tab.getButton());
			this.getPane().add(tab.getPage());
			this.set({minHeight: "auto", minWidth: "auto"});
			
			tab.getButton().addEventListener("closetab", function(e) {
				var b = e.getData();
				var tabs = _this.getTabs();
				
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
			});
			
			this.getTabs().add(tab);
		}
	}
});
