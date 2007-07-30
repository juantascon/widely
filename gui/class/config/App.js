qx.Class.define("config.App",
{
	extend: lib.WApp,
	
	members:
	{
		main: function(e) {
			this.base(arguments);
			
			this.init_wapp("config", "user");
			this.init_mainframe();
			this.init_session();
		},
		
		init: function (){
			qx.Class.createNamespace("global.configview", new config.ConfigView);
			global.mainframe.add(global.configview);
		}
	}
});
