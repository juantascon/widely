qx.Class.define("ide.ToolBar",
{
	extend: lib.ui.toolbar.Horizontal,
	
	include: lib.dao.api.Auth,
	
	construct: function () {
		this.base(arguments, 32);
		
		this.add_part([
			{
				type: "button", permanent: true,
				label: "Browse (WebDav)",icon: "apps/system-file-manager",
				execute: function(e){
					lib.ui.Msg.info(this, "if you are using konqueror(recommended)<br/> you can browse your webdav directory at:<br/>webdav://&lt;server&gt;/data/&lt;username&gt;");
					
				}, _this: this
			},
			{
				type: "button", permanent: true,
				label: "Change Working Copy", icon: "places/document-folder",
				execute: function(e){
					global.app.instance.set_wc();
				}, _this: this
			},
			{
				type: "button", permanent: true,
				label: "Config", icon: "apps/preferences",
				execute: function(e){
					//lib.lang.Redirect.redirect_to("./config.html");
					(new qx.client.NativeWindow("./config.html")).open()
					
				}, _this: this
			}
		]);
		
		this.add(new qx.ui.basic.HorizontalSpacer);
		
		this.add_part([
			{
				type: "button", permanent: true,
				label: "Help", icon: "categories/system-help",
				execute: function(e){
				
				}, _this: this
			}
		]);
		
		this.add_part([
			{
				type: "button", permanent: true,
				label: "Logout", icon: "actions/application-exit",
				execute: function(e){
					var confirm = lib.ui.Msg.warn(global.mainframe, "Do you really want to logout?");
					confirm.addEventListener("ok", function(e) {
						this.debug("OK");
						global.app.instance.quit();
					});
				}, _this: this
			}
		]);
		
	}
});
