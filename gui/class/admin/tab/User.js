qx.Class.define("admin.tab.User",
{
	extend: lib.ui.PageViewTab,
	
	include: [ lib.dao.api.User, lib.dao.api.Auth ],
	
	
	properties:
	{
		editablelistview: { check: "lib.ui.EditableListView" }
	},
	
	construct: function () {
		this.base(arguments,
			"buttonview",
			"Users",
			"icon/32/apps/system-users.png");
		
		this.setEditablelistview(new lib.ui.EditableListView( {
			user_id: {
				label: "User ID",
				icon: "icon/16/apps/system-users.png",
				width: "100%",
				type: "text"
			}
		} ));
		
		with (this.getEditablelistview()) {
			addEventListener("load", function(e){
				var wrq = this.user_list();
				wrq.addEventListener("ok", function(e){
					this.load_list(e.getData());
				}, this);
			}, this);
		}
		
		with(this.getEditablelistview().getToolbar()) {
			add_button("Edit User Config", "actions/edit", true, function(e) {
				var user_id = this.getEditablelistview().selected("user_id");
				
				var user_session_rq = this.auth_user_session(user_id);
				user_session_rq.addEventListener("ok", function(e) {
					var session_id = e.getData();
					lib.dao.Cookie.set_session_id("config", session_id);
					this.debug(user_id);
					var config_window = new qx.client.NativeWindow("./config.html");
					config_window.open();
				}, this);
			}, this);
		}
		
		this.getPage().add(this.getEditablelistview());
		this.getPage().setPadding(50);
	},
	
	members:
	{
		load_list: function(data){
			while(this.getEditablelistview().getListview().getData().pop());
			
			for (var i in data){
				this.getEditablelistview().getListview().getData().push({
					user_id: {text: data[i]["user_id"]}
				});
			}
		}
	}
});