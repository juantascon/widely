qx.Class.define("editor.TabView",
{
	extend: qx.ui.pageview.tabview.TabView,
	construct: function () {
		qx.ui.pageview.tabview.TabView.call(this, "vertical");
		this.set({left: 0, right: 0, top: 0, bottom: 0});
	},
	
	members:
	{
		tabs: new lang.List,
		
		selected_tab: function(){
			var b = this.getBar().getManager().getSelected();
			for (var i = 0; i < this.tabs.length(); i++){
				if (this.tabs.get(i).button == b){
					return this.tabs.get(i);
				}
			}
			return null;
		},
		
		add_tab: function(file){
			var _this = this;
			
			for (var i = 0; i < this.tabs.length(); i++){
				if (this.tabs.get(i).file == file){
					this.tabs.get(i).button.setChecked(true);
					return;
				}
			}
			
			var tab = new editor.Tab(file);
			with(this) {
				getBar().add(tab.button);
				getPane().add(tab.page);
				set({minHeight: "auto", minWidth: "auto"});
			}
			
			tab.button.addEventListener("closetab", function(e) {
				var b = e.getData();
				var tabs = _this.tabs;
				
				if (tabs.length() <= 1){
					return;
				}
				for (var i = 0; i < tabs.length(); i++) {
					if (tabs.get(i).button == b){
						tab = tabs.get(i);
						
						tabs.remove(i).button.setChecked(true);
						
						_this.getBar().remove(tab.button);
						_this.getPane().remove(tab.page);
						tab.button.dispose();
						tab.page.dispose();
						
						break;
					}
				}
				e.stopPropagation();
			});
			
			this.tabs.add(tab);
		}
	}
});
