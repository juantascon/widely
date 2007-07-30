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
					var confirm = lib.ui.Msg.warn("Do you really want to logout?");
					confirm.addEventListener("ok", function(e) {
						global.app.instance.quit();
					});
				}, _this: this
			},
			{
				type: "button", permanent: true,
				label: "Change Working Copy", icon: "places/document-folder",
				execute: function(e){
					
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
				
				}, _this: this
			}
		]);
		
	}
});
