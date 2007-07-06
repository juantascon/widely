qx.Class.define("config.tab.RepoTab",
{
	extend: config.tab.Tab,
	
	include: lib.dao.Repo,
	
	properties:
	{
		editablelistview: { check: "lib.ui.EditableListView" }
	},
	
	construct: function () {
		this.base(arguments, "Repositories", "icon/32/places/archive-folder.png");
		
		this.setEditablelistview(new lib.ui.EditableListView( {
			name: {
				label: "Name",
				icon: "icon/16/categories/applications-development.png",
				width: "50%",
				type: "text"
			},
			manager: {
				label: "Manager",
				icon: "icon/16/apps/accessories-archiver.png",
				width: "50%",
				type: "text"
			}
		} ));
		
		with (this.getEditablelistview()) {
			addEventListener("load", function(e){
				var wrq = this.dao_list();
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
					name: {text: data[i]["name"]},
					manager: {text: data[i]["manager"]}
				});
			}
		}
	}
});
