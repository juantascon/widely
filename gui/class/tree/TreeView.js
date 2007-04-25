qx.OO.defineClass("tree.TreeView", qx.ui.layout.BoxLayout,
function () {
	qx.ui.layout.BoxLayout.call(this, "vertical");
	this.set({ left: 0, top: 0, right: 0, bottom: 0 });
	
	this.tree = new qx.ui.treefullcontrol.Tree(this.trs.standard("/"));
	with(this.tree)
	{
		setBackgroundColor(255);
		setOverflow("auto");
		setHideNode(true);
		setBorder(new qx.renderer.border.Border(1, "solid", "#91A5BD"));
		set({minHeight: 200, height: "100%"});
	}
	
	this.load_tree();
	this.add(this.tree);
});

qx.Proto.trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance();
qx.Proto.tree = null;

qx.Proto.load_tree = function(){
	var rq = new qx.io.remote.Request("/api/wc/ls", "POST", qx.util.Mime.JSON);
	rq.setData("wc_id=0&path=/");
	
	rq.addEventListener("completed", function(e){
		resp = e.getData();
		if (resp.getStatusCode() == 200){ // Status: OK
			data = resp.getContent();
			for (var i in data){
				if (data[i]["type"] == "dir"){
					tree.TreeView.getInstance().tree.addToFolder(tree.Dir.new_from_hash(data[i]));
				}
				if (data[i]["type"] == "file"){
					tree.TreeView.getInstance().tree.addToFolder(tree.File.new_from_hash(data[i]));
				}
			}
		}
	});
	
	rq.send();
	
};

qx.Clazz.getInstance = qx.lang.Function.returnInstance;
