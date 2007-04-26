qx.OO.defineClass("tree.File", qx.ui.treefullcontrol.TreeFile,
function (name, path) {
	var self = this;
	
	this.setName(name);
	this.setPath(path);
	
	qx.ui.treefullcontrol.TreeFile.call(this, this.trs.standard(name, this.icon));
	
	this.addEventListener("click", function(e){
		editor.EditorView.getInstance().add_tab(self);
	});
});

qx.Proto.trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance();
qx.Proto.icon = "icon/16/mimetypes/text-ascii.png";

qx.OO.addProperty({ name : "name", type : "string", defaultValue : "" });
qx.OO.addProperty({ name : "path", type : "string", defaultValue : "" });
qx.OO.addProperty({ name : "content", type : "string", defaultValue : "" });

qx.Proto.load_content = function(text_area){
	var rq = new qx.io.remote.Request("/api/wc/cat", "POST", qx.util.Mime.JSON);
	rq.setData("wc_id=0&path="+encodeURI(this.getPath()));
	
	rq.addEventListener("completed", function(e){
		resp = e.getData();
		if (resp.getStatusCode() == 200){ // Status: OK
			data = resp.getContent();
			if (data){
				text_area.setValue(""+data);
			}
		}
	});
	
	rq.send();
}

qx.Clazz.new_from_hash = function(h){
	return new tree.File(h["text"], h["id"]);
};
