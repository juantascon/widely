qx.Class.define("tree.File",
{
	extend: qx.ui.tree.TreeFile,
	
	construct: function (name, path) {
		qx.ui.tree.TreeFile.call(this, name);
		var _this = this;
		
		this.setName(name);
		this.setPath(path);
		
		this.addEventListener("click", function(e){
			editor.EditorView.getInstance().getTabview().add_tab(_this);
		});
	},
	
	properties:
	{
		name: { check: "String", init: "" },
		path: { check: "String", init: ""},
		textarea: { check: "qx.ui.form.TextArea" }
	},
	
	members:
	{
		load: function(){
			var _this = this;
			
			var rq = new qx.io.remote.Request("/api/wc/cat", "POST", qx.util.Mime.JSON);
			rq.setData("wc_id=0&path="+encodeURI(this.getPath()));
			
			rq.addEventListener("completed", function(e){
				resp = e.getData();
				if (resp.getStatusCode() == 200){ // Status: OK
					data = resp.getContent();
					if (data){
						_this.getTextarea().setValue(""+data);
					}
				}
			});
			
			rq.send();
		},
		
		save: function(){
			var rq = new qx.io.remote.Request("/api/wc/write", "POST", qx.util.Mime.JSON);
			rq.setData("wc_id=0&path="+encodeURI(this.getPath())+"&content="+"contenido");
			
			rq.addEventListener("completed", function(e){
				resp = e.getData();
				if (resp.getStatusCode() == 200){ // Status: OK
					data = resp.getContent();
					if (data){
						this.getTextarea().setValue(""+data);
					}
				}
			});
			
			rq.send();
		}
	},
	
	statics:
	{
		new_from_hash: function(h){
			return new tree.File(h["text"], h["id"]);
		}
	}
});
