qx.Class.define("lang.WRequest",
{
	extend: qx.io.remote.Request,
	
	construct: function (webservice, method, params, validator, _this) {
		this.base(arguments, "/api/"+webservice+"/"+method, "POST", qx.util.Mime.JSON);
		
		this.setData(lang.Encode.encodeObj(params));
		
		this.addEventListener("completed", function(e){
			resp = e.getData();
			if (resp.getStatusCode() == 200){ // Status: OK
				var data = resp.getContent();
				validator.call(this, data);
			}
		}, _this);
	}
});