qx.OO.defineClass("toolbar.Tools", qx.ui.layout.BoxLayout,
function () {
	qx.ui.layout.BoxLayout.call(this, "vertical");
	this.set({ left: 0, top: 0, right: 0, bottom: 0 });
	
	b = new qx.ui.toolbar.Button("Save", "icon/22/actions/save/document-save.png");
	/*d.addEventListener("changeLayout", changeLayout, o);
	d.addEventListener("changeSize", changeSize, o);
	o.addEventListener("execute", buttonExecute);*/
	
});

qx.Clazz.getInstance = qx.lang.Function.returnInstance;
