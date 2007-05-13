qx.Class.define("ui.cmd.FileTree",
{
	type: "static",
	
	statics:
	{
		load: function(){
			main.Obj.selector.getFiletree().load();
		},
		
		new_file: function() {
			if (main.Obj.selector.getFiletree().is_read_only()) {
				main.Obj.statusbar.fail("Add: readonly tree");
				return;
			}
			
			var dir_d = new ui.component.WCDirDialog("New File", "Where?");
			dir_d.addEventListener("ok", function(e) {
				var path = dir_d.selected_dir().getPath();
				var selected = main.Obj.selector.getFiletree().find_child_by_path(path);
				
				var name_d = new ui.component.InputDialog("New File", "New file name:");
				name_d.addEventListener("ok", function(e) {
					var name = name_d.get_text();
					
					selected.add(new ui.selector.File(name, path+name));
					main.Obj.selector.getFiletree().dao_add(path+name);
				});
				
			});
		},
		
		delete_selected:  function() {
			if (main.Obj.selector.getFiletree().is_read_only()) {
				main.Obj.statusbar.fail("Delete: readonly tree");
				return;
			}
			
			var selected = main.Obj.selector.getFiletree().getSelectedElement();
			var d = new ui.component.YesNoDialog("Delete", "Are you sure want to delele: "+selected.getPath());
			d.addEventListener("ok", function(e) {
				selected.dao_delete();
				selected.destroy();
			});
		},
		
		commit: function() {
			if (main.Obj.selector.getFiletree().is_read_only()) {
				main.Obj.statusbar.fail("Commit: readonly tree");
				return;
			}
			
			var name_d = new ui.component.InputDialog("Commit", "Version name:");
			name_d.addEventListener("ok", function(e) {
				var name = name_d.get_text();
				
				main.Obj.selector.getFiletree().dao_commit(name);
			});
			
			
		}
	}
});