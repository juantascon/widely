/*
 * Permite hacer una peticion al servidor y controlar su estado por medio
 * de eventos
 *
 */
qx.Class.define("lib.dao.WRQ",
{
	extend: qx.io.remote.Request,
	
	events:
	{
		// La peticion se ha completado bien
		"ok": "qx.event.type.DataEvent",
		// La peticion fallo
		"fail": "qx.event.type.DataEvent"
	},
	
	/*
	 * webservice: el nombre del webservice en el servidor
	 * method: el nombre del metodo en el webservice
	 * params: los parametros a pasar al metodo
	 * msg: el mensaje para mostrar en la barra de estado
	 *
	 */
	construct: function (webservice, method, params, msg) {
		this.base(arguments, "/api/"+webservice+"/"+method, "POST", qx.util.Mime.JSON);
		
		// Los paramentros deben ir con codificacion URI
		this.setData(lib.lang.Encode.encodeObj(params));
		
		// Si la peticion es abortada se lanza el evento fail
		this.addEventListener("aborted", function(e){
			this.createDispatchDataEvent("fail", "aborted");
			global.statusbar.fail(msg+": aborted");
		}, this);
		
		// Si la peticion fall se lanza el evento fail
		this.addEventListener("failed", function(e){
			this.createDispatchDataEvent("fail", "failed");
			global.statusbar.fail(msg+": failed");
		}, this);
		
		// Si se acaba el tiempo de la peticion se lanza el evento fail
		this.addEventListener("timeout", function(e){
			this.createDispatchDataEvent("fail", "timeout");
			global.statusbar.fail(msg+": timeout");
		}, this);
		
		this.addEventListener("completed", function(e){
			resp = e.getData();
			var data = resp.getContent();
			
			/*
			 * Si el campo status de la respuesta es ok se lanza el evento ok
			 * si es fail se lanza el evento fail
			 *
			 */
			if (data["status"] == "ok") {
				this.createDispatchDataEvent("ok", data["obj"])
				global.statusbar.ok(msg+": OK");
			}
			else if (data["status"] == "fail") {
				this.createDispatchDataEvent("fail", data["message"]);
				global.statusbar.fail(msg+": error -- invalid request");
			}
			
		}, this);
		
		// Se envia la peticion al servidor
		global.statusbar.process(msg+": sending");
		this.send();
	}
});
