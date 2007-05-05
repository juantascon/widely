qx.Mixin.define("dao.Tree",
{
	members:
	{
		load: function(){
			var rq = new lang.WRequest(
				"wc", "ls",
				{ wc_id: 0, path: "/" },
				function(data){
					this.load_from_hash(data);
				},
				this
			);
			
			rq.send();
		}
	}
});
