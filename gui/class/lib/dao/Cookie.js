/*
 * Facilita el manejo de las cookies de las aplicaciones
 * el unico valor que se debe almacenar es un identificador de la
 * session del usuario
 *
 */
qx.Class.define("lib.dao.Cookie",
{
	type: "static",
	
	statics:
	{
		/*
		 * Almacena el identificador de la session
		 *
		 * app: la aplicacion para identificar a quien pertenece la cookie
		 * session_id: el identificador de la session
		 */
		set_session_id: function(app, session_id) {
			qx.io.local.CookieApi.set(app+".session_id", session_id);
		},
		
		/*
		 * obtiene el identificador de session para la aplicacion actual
		 *
		 */
		get_session_id: function() {
			return qx.io.local.CookieApi.get(global.app.name+".session_id");
		}
	}
});
