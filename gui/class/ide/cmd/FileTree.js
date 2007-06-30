qx.Class.define("ide.cmd.FileTree",
{
	type: "static",
	
	statics:
	{
		delete_selected:  function() {
			if (core.Obj.selector.getFiletree().is_read_only()) {
				core.Obj.statusbar.fail("Delete: readonly tree");
				return;
			}
			
			var selected = core.Obj.selector.getFiletree().getSelectedElement();
			var d = new ui.component.YesNoDialog("Delete", "Are you sure want to delele: "+selected.getPath());
			d.addEventListener("ok", function(e) {
				selected.dao_delete();
				selected.destroy();
			});
		},
		
		commit: function() {
			if (core.Obj.selector.getFiletree().is_read_only()) {
				core.Obj.statusbar.fail("Commit: readonly tree");
				return;
			}
			
			var name_d = new ui.component.InputDialog("Commit", "Version name:");
			name_d.addEventListener("ok", function(e) {
				var name = name_d.get_text();
				
				core.Obj.selector.getFiletree().dao_commit(name);
			});
			
			
		}
	}
});