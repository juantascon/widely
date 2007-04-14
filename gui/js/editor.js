EditArea = function(){
}

EditArea.prototype = {
	editarea_div: "editarea",
	editarea_el: null,
	editarea_resize: null,
	keymap_tab: null,
	
	init: function(){
		this.editarea_el = Ext.get(this.editarea_div);
		this.editarea_resize = new Ext.Resizable(this.editarea_el, {
			wrap:true,
			pinned:true,
			width:700,
			height:500,
			minWidth:600,
			minHeight: 400,
			dynamic: false
		});
		
		this.keymap_tab = new Ext.KeyMap(this.editarea_el, {
			key: "\t",
			fn: function(){
				alert: ("hopla");
			}
		});
    }
}
	
Editor = function(){
	var editarea = new EditArea();
	var editor_el = Ext.get("editor");
	var mgr = editor_el.getUpdateManager();
	mgr.setDefaultUrl("cgi/content.cgi");
	mgr.refresh(editarea.init.createDelegate(editarea));
}
