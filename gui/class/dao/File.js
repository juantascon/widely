qx.Mixin.define("dao.File",
{
	properties:
	{
		name: { check: "String", init: "" },
		path: { check: "String", init: ""},
		textarea: { check: "qx.ui.form.TextArea" }
	},
	
	members:
	{
		load: function(){
			var rq = new lang.WRequest(
				"wc", "cat",
				{ wc_id: 0, path: this.getPath() },
				function(data){
					this.getTextarea().setValue(""+data);
				},
				this
			);
			rq.send();
		},
		
		save: function(){
			var rq = new lang.WRequest(
				"wc", "write",
				{
					wc_id: 0,
					path: this.getPath(),
					content: this.getTextarea().getComputedValue()
				},
				function(data){
					this.debug("save: "+data);
				},
				this
			);
			rq.send();
		}
	}
});
