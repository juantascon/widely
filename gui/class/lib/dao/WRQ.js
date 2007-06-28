qx.Class.define("lib.dao.WRQ",
{
	extend: qx.io.remote.Request,
	
	construct: function (webservice, method, params, msg) {
		this.base(arguments, "/api/"+webservice+"/"+method, "POST", qx.util.Mime.JSON);
		
		this.setTimeout(15000);
		
		this.setData(lib.lang.Encode.encodeObj(params));
		
		this.addEventListener("aborted", function(e){
			widely.statusbar.fail(msg+": aborted");
			this.createDispatchEvent("fail");
		}, this);
		
		this.addEventListener("failed", function(e){
			widely.statusbar.fail(msg+": failed");
			this.createDispatchEvent("fail");
		}, this);
		
		this.addEventListener("timeout", function(e){
			widely.statusbar.fail(msg+": timeout");
			this.createDispatchEvent("fail");
		}, this);
		
		
		this.addEventListener("completed", function(e){
			resp = e.getData();
			var data = resp.getContent();
			
			if (data["error"]) {
				widely.statusbar.fail(msg+": error -- invalid request");
				
				this.createDispatchDataEvent("error", data["error"])
			}
			else if (resp.getStatusCode() == 200){ // Status: OK
				widely.statusbar.ok(msg+": OK");
				
				this.createDispatchDataEvent("ok", data)
			}
			else {
				widely.statusbar.fail(msg+": error -- invalid request");
				
				this.createDispatchDataEvent("error", data)
			}
		}, this);
		
		widely.statusbar.process(msg+": sending");
		this.send();
	},
	
	events:
	{
		"fail": "qx.event.type.Event",
		"ok": "qx.event.type.Event",
		"error": "qx.event.type.Event"
	}
	
});
