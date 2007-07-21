qx.Class.define("lib.dao.WRQ",
{
	extend: qx.io.remote.Request,
	
	events:
	{
		"ok": "qx.event.type.DataEvent",
		"fail": "qx.event.type.DataEvent"
	},
	
	construct: function (webservice, method, params, msg) {
		this.base(arguments, "/api/"+webservice+"/"+method, "POST", qx.util.Mime.JSON);
		
		this.setData(lib.lang.Encode.encodeObj(params));
		
		this.addEventListener("aborted", function(e){
			this.createDispatchDataEvent("fail", "aborted");
			global.statusbar.fail(msg+": aborted");
		}, this);
		
		this.addEventListener("failed", function(e){
			this.createDispatchDataEvent("fail", "failed");
			global.statusbar.fail(msg+": failed");
		}, this);
		
		this.addEventListener("timeout", function(e){
			this.createDispatchDataEvent("fail", "timeout");
			global.statusbar.fail(msg+": timeout");
		}, this);
		
		
		this.addEventListener("completed", function(e){
			resp = e.getData();
			var data = resp.getContent();
			
			if (data["status"] == "ok") {
				this.createDispatchDataEvent("ok", data["obj"])
				global.statusbar.ok(msg+": OK");
			}
			else if (data["status"] == "fail") {
				this.createDispatchDataEvent("fail", data["message"]);
				global.statusbar.fail(msg+": error -- invalid request");
			}
			
		}, this);
		
		global.statusbar.process(msg+": sending");
		this.send();
	}
});
