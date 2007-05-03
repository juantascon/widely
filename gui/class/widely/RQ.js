qx.Class.define("widely.RQ",
{
	extend: qx.io.remote.Request,
	construct: function (webservice, method, params, validator) {
		var _this = this;
		qx.io.remote.Request.call(this, "/api/"+webservice+"/"+method, "POST", qx.util.Mime.JSON);
		this.setData(lang.Encode.encodeObj(params));
		
		this.addEventListener("completed", function(e){
			resp = e.getData();
			if (resp.getStatusCode() == 200){ // Status: OK
				var data = resp.getContent();
				validator.call(this, data);
			}
		});
	}
});
