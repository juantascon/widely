FullLoader = function(url){
	FullLoader.superclass.constructor.call(this, { dataUrl: url, baseParams: {myname: "juandiego", myid: "000001"} });
}

Ext.extend ( FullLoader, Ext.tree.TreeLoader, {
	processResponse : function(response, node, callback){
		var json = response.responseText;
		try {
			var o = eval("("+json+")");
			this.create_nodes(node, o);
			if(typeof callback == "function"){
				callback(this, node);
			}
		}catch(e){
			this.handleFailure(response);
		}
	},
	
	create_nodes: function(parent_node, data){
		for(var i = 0, len = data.length; i < len; i++){
			var new_node = this.createNode(data[i]);
			if (data[i].childs){
				this.create_nodes(new_node, data[i].childs);
			}
			parent_node.appendChild(new_node);
		}
	},
	
	createNode : function(attr) {
		attr.loader = this;
		return new Ext.tree.TreeNode(attr);
		return node;
	}
});

FileTreeView = function() {
	FileTreeView.superclass.constructor.call(this, "filetreeview", {
		animate: true,
		loader: new FullLoader("./cgi/fs.cgi"),
		enableDD: true,
		containerScroll: true
	});
	
	this.setRootNode(new Ext.tree.AsyncTreeNode({
		text: 'yui-ext',
		draggable: false,
		id: 'root'
	}));
	this.render();
	this.load();
};

Ext.extend ( FileTreeView, Ext.tree.TreePanel, {
	load: function(){
		this.getEl().setVisible(false);
		this.getRootNode().reload();
		this.getEl().setVisible(true);
	}
});
