qx.OO.defineClass("editor.Tab", qx.core.Object,
function (file) {
	qx.core.Object.call(this);
	
	this.file = file;
	
	this.button = new qx.ui.pageview.tabview.Button(file.getName());
	this.button.setChecked(true);
	this.button.setShowCloseButton(true);
	
	this.area = new qx.ui.form.TextArea("contenido");
	this.area.set({ height: "100%", width: "100%" });
	this.area.setOverflow("scrollY");
	
	this.page = new qx.ui.pageview.tabview.Page(this.button);
	this.page.add(this.area);
});

qx.Proto.file = null;
qx.Proto.button = null;
qx.Proto.page = null;
qx.Proto.textarea = null;

