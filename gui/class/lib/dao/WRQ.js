qx.Class.define("lib.dao.WRQ",
{
	extend: qx.io.remote.Request,
	
	construct: function (webservice, method, params, msg) {
		this.base(arguments, "/api/"+webservice+"/"+method, "POST", qx.util.Mime.JSON);
		
		this.setTimeout(15000);
		
		this.setData(lib.lang.Encode.encodeObj(params));
		
		this.addEventListener("aborted", function(e){
			this.createDispatchEvent("fail");
			global.statusbar.fail(msg+": aborted");
		}, this);
		
		this.addEventListener("failed", function(e){
			this.createDispatchEvent("fail");
			global.statusbar.fail(msg+": failed");
		}, this);
		
		this.addEventListener("timeout", function(e){
			this.createDispatchEvent("fail");
			global.statusbar.fail(msg+": timeout");
		}, this);
		
		
		this.addEventListener("completed", function(e){
			resp = e.getData();
			var data = resp.getContent();
			
			if (data["error"]) {
				this.createDispatchDataEvent("error", data["error"])
				global.statusbar.fail(msg+": error -- invalid request");
			}
			else if (resp.getStatusCode() == 200){ // Status: OK
				this.createDispatchDataEvent("ok", data)
				global.statusbar.ok(msg+": OK");
			}
			else {
				this.createDispatchDataEvent("error", data)
				global.statusbar.fail(msg+": error -- invalid request");
			}
		}, this);
		
		global.statusbar.process(msg+": sending");
		this.send();
	},
	
	events:
	{
		"fail": "qx.event.type.Event",
		"ok": "qx.event.type.Event",
		"error": "qx.event.type.Event"
	}
	
});
