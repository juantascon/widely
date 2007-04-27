qx.Class.define("toolbar.Tools",
{
	type: "singleton",
	extend: qx.ui.layout.BoxLayout,
	construct: function () {
		qx.ui.layout.BoxLayout.call(this, "vertical");
		this.set({ left: 0, top: 0, right: 0, bottom: 0 });
		
		b = new qx.ui.toolbar.Button("Save", "icon/22/actions/save/document-save.png");
		/*d.addEventListener("changeLayout", changeLayout, o);
		d.addEventListener("changeSize", changeSize, o);
		o.addEventListener("execute", buttonExecute);*/
		
	}
});
