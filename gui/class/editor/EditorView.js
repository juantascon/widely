qx.OO.defineClass("editor.EditorView", qx.ui.pageview.tabview.TabView,
function () {
	qx.ui.pageview.tabview.TabView.call(this);
	
	this.set({ left: 0, top: 0, right: 0, bottom: 0 });
	this.add_tab(new tree.File("file1"));
	this.add_tab(new tree.File("file2"));
	this.add_tab(new tree.File("file3"));
	this.add_tab(new tree.File("file4"));
});

qx.Proto.tabs = new lang.List;

qx.Proto.add_tab = function(file){
	for (var i = 0; i < this.tabs.length(); i++){
		if (this.tabs.get(i).file == file){
			this.tabs.get(i).button.setChecked(true);
			return;
		}
	}
	
	tab = new editor.Tab(file);
	this.getBar().add(tab.button);
	this.getPane().add(tab.page);
	this.tabs.add(tab);
	
	tab.button.addEventListener("closetab", function(e) {
		var b = e.getData();
		var tabs = editor.EditorView.getInstance().tabs;
		
		if (tabs.length() <= 1){
			return;
		}
		for (var i = 0; i < tabs.length(); i++) {
			if (tabs.get(i).button == b){
				tab = tabs.get(i);
				
				tabs.remove(i).button.setChecked(true);
				
				editor.EditorView.getInstance().getBar().remove(tab.button);
				editor.EditorView.getInstance().getPane().remove(tab.page);
				tab.button.dispose();
				tab.page.dispose();
				
				break;
			}
		}
		e.stopPropagation();
	});
};

qx.Clazz.getInstance = qx.lang.Function.returnInstance;
