qx.Class.define("editor.EditorView",
{
	type: "singleton",
	extend: qx.ui.layout.BoxLayout,
	construct: function () {
		var _this = this;
		qx.ui.layout.BoxLayout.call(this, "vertical");
		
		this.setEdge(0);
		this.set({left: 0, right: 0, top: 0, bottom: 0});
		this.setHeights("100%");
		this.setWidths("100%");
		
		this.tabview = new qx.ui.pageview.tabview.TabView;
		this.tabview.set({left: 0, right: 0, top: 0, bottom: 0});
		this.add(this.tabview);
		
		this.add_tab(new tree.File("file1", "/file1"));
	},
	
	members:
	{
		tabview: null,
		tabs: new lang.List,
		
		selected_tab: function(){
			var b = this.tabview.getBar().getManager().getSelected();
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
			
			tab = new editor.Tab(file);
			with(this.tabview) {
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
						
						_this.tabview.getBar().remove(tab.button);
						_this.tabview.getPane().remove(tab.page);
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
