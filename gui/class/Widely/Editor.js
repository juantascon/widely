qx.OO.defineClass("Widely.Editor", qx.ui.pageview.tabview.TabView,
function () {
	qx.ui.pageview.tabview.TabView.call(this);
	
	this.set({ left: 0, top: 0, right: 0, bottom: 0 });
	
	var t1_1 = new qx.ui.pageview.tabview.Button("Edit");
	var t1_2 = new qx.ui.pageview.tabview.Button("Find");
	
	// set tab 1 active
	t1_1.setChecked(true);
	
	// add close images to tab
	t1_1.setShowCloseButton(true);
	t1_2.setShowCloseButton(true);
	
	// add an eventlistener on the buttons
	t1_1.addEventListener("closetab", _ontabclose);
	t1_2.addEventListener("closetab", _ontabclose);
	
	
	// this handler gets called if a tab-button fires a "closetab" event
	function _ontabclose(e){
		var btn = e.getData();
		btn.getManager().remove(btn);
		tf1.getBar().remove(btn);
		btn.dispose();
		
		var pagesArray = tf1.getPane().getChildren();
		var pageSearched = null;
		
		e.stopPropagation();
	}
	
	this.getBar().add(t1_1, t1_2);
	
	var p1_1 = new qx.ui.pageview.tabview.Page(t1_1);
	var p1_2 = new qx.ui.pageview.tabview.Page(t1_2);
	
	this.getPane().add(p1_1, p1_2);
});
