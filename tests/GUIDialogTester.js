qx.Class.define("main.Widely",
{
	extend: qx.component.AbstractApplication,
	
	construct : function() {
		this.base(arguments);
	},
	
	members:
	{
		initialize: function(e) {},
		
		main: function(e) {
			ui.StatusBar.getInstance();
			var btnOpen = new qx.ui.form.Button("Open the dialog");
			btnOpen.set({ top : 50, left : 20 });
			btnOpen.addEventListener("click", function(e) {
				var w = new ui.component.WCDirDialog("Confirme", "Selecciona el nuevo Directorio:");
				w.start();
			});
			btnOpen.addToDocument();
		},
		
		finalize: function(e) {},
		
		close: function(e) {},
		
		terminate: function(e) {}
	},
	
	settings:
	{
		"main.resourceUri": "./resource"
	}
});
