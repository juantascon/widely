/*
 * La vista principal para la administracion
 * del servidor y los usuarios
 *
 */
qx.Class.define("ide.selector.SelectorView",
{
	extend: qx.ui.layout.VerticalBoxLayout,
	
	properties:
	{
		// El arbol de archivos
		tree: { check: "ide.selector.fs.Tree" },
		
		// La barra de herramientas
		toolbar: { check: "ide.selector.ToolBar" },
		
		// La tabla de versiones
		versionstable: { check: "ide.selector.VersionsTable" },
		splitbox: { check: "qx.ui.splitpane.VerticalSplitPane" }
	},
	
	construct: function () {
		this.base(arguments);
		
		this.setEdge(0);
		this.set({height: "100%", width: "100%"});
		
		this.setToolbar(new ide.selector.ToolBar());
		this.getToolbar().set({left: 0, top: 0});
		this.add(this.getToolbar());
		
		this.setTree(new ide.selector.fs.Tree());
		this.setVersionstable(new ide.selector.VersionsTable());
		
		// El arbol de archivos y la tabla de versiones van en un splitbox
		this.setSplitbox(new qx.ui.splitpane.VerticalSplitPane("3*", "2*"));
		with(this.getSplitbox()) {
			set({height: "100%", width: "100%"});
			addTop(this.getTree());
			addBottom(this.getVersionstable());
		}
		this.add(this.getSplitbox());
	},
	
	members:
	{
		/*
		 * Cambia la version actual del arbol de archivos
		 *
		 * version: la nueva version del arbol de archivos
		 *
		 */
		set_tree_version: function(version){
			this.getSplitbox().getTopArea().remove(this.getTree());
			/*
			 * TODO: se deben borrar los FileTree del view?
			 *
			 * this.getTree().dispose();
			 *
			 */
			this.setTree(new ide.selector.fs.Tree(version));
			this.getTree().load();
			this.getSplitbox().addTop(this.getTree());
		}
	}
});
