qx.Class.define("admin.tab.User",
{
	extend: lib.ui.PageViewTab,
	
	include: lib.dao.api.User,
	
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
			name: {
				label: "User ID",
				icon: "icon/16/apps/system-users.png",
				width: "100%",
				type: "text"
			}
		} ));
		
		with(this.getEditablelistview().getToolbar()) {
			add_button("Edit User Config", "actions/edit", true, function(e){
				qx.io.local.CookieApi;
			}, this);
		}
		
		with (this.getEditablelistview()) {
			addEventListener("load", function(e){
				var wrq = this.user_list();
				wrq.addEventListener("ok", function(e){
					this.load_list(e.getData());
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
					name: {text: data[i]["user_id"]}
				});
			}
		}
	}
});
