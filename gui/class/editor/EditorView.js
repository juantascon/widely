qx.Class.define("editor.EditorView",
{
	type: "singleton",
	extend: qx.ui.layout.VerticalBoxLayout,
	construct: function () {
		qx.ui.layout.VerticalBoxLayout.call(this);
		var _this = this;
		
		this.setEdge(0);
		this.set({left: 0, right: 0, top: 0, bottom: 0});
		this.setHeights("100%");
		this.setWidths("100%");
		
		this.tabview = new editor.TabView();
		this.tabview.add_tab(new tree.File("file1", "/file1"));
		this.filetoolbar = new editor.FileToolBar();
		
		this.add(this.filetoolbar);
		this.add(this.tabview);
	},
	
	members:
	{
		tabview: null,
		filetoolbar: null
	}
});
