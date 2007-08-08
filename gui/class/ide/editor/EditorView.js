/*
 * La vista de edicion de archivos
 *
 */
qx.Class.define("ide.editor.EditorView",
{
	extend: qx.ui.layout.VerticalBoxLayout,
	
	properties:
	{
		// La vista de tabs
		tabview: { check: "ide.editor.TabView" },
		// la barra de herramientas
		toolbar: { check: "ide.editor.ToolBar" }
	},
	
	construct: function () {
		this.base(arguments);
		
		this.set({height: "100%", width: "100%"});
		
		this.setTabview(new ide.editor.TabView());
		this.setToolbar(new ide.editor.ToolBar());
		this.getToolbar().set({left: 0, top: 0});
		
		this.add(this.getToolbar());
		this.add(this.getTabview());
	}
});
