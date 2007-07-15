qx.Class.define("config.App",
{
	extend: lib.WApp,
	
	members:
	{
		main: function (e){
			this.base(arguments, "config");
			
			this.init_session("user", function() {
				qx.Class.createNamespace("global.configview", new config.ConfigView);
				global.mainframe.add(global.configview);
			}, this);
		}
	}
});
