/*
 * Aqui se hacen todas las redirecciones de la pagina actual
 *
 */
qx.Class.define("lib.lang.Redirect",
{
	type: "static",
	
	statics:
	{
		/*
		 * redirecciona el navegador hacia la pagina <url> cambiando la
		 * propiedad del navegador window.location
		 *
		 * url: la pagina a redireccionar
		 *
		 */
		redirect_to: function(url) {
			if (qx.util.Validation.isInvalidString(url)) { return false; }
			
			window.location = url;
		},
		
		/*
		 * Redirecciona hacia la pagina por defecto (login)
		 *
		 */
		fallback_redirect: function() {
			var fallback_url = "./login.html";
			lib.lang.Redirect.redirect_to(fallback_url);
		}
	}
});
