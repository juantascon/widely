/*
 * Clase abstracta que define una aplicacion
 *
 * Todas las apliciones de la interfaz deben heredar de esta clase
 *
 */
qx.Class.define("lib.WApp",
{
	type: "abstract",
	
	extend: qx.application.Gui,
	
	include: lib.dao.api.Auth,
	
	members:
	{
		/*
		 * Inicia las variables globales asociadas a la aplicacion
		 *
		 * name: el nombre de la aplicacion
		 * type: el tipo de la aplicacion <admin|user>
		 *
		 */
		init_wapp: function(name, type) {
			qx.Class.createNamespace("global.app.name", name);
			qx.Class.createNamespace("global.app.instance", this);
			qx.Class.createNamespace("global.app.type", type);
		},
		
		/*
		 * Inicia la interfaz principal (el frame y la barra de estado
		 * y la adiciona al DOM
		 *
		 */
		init_mainframe: function() {
			qx.Class.createNamespace("global.mainframe", new qx.ui.layout.DockLayout);
			qx.Class.createNamespace("global.statusbar", new lib.ui.StatusBar);
			
			with(global.mainframe) {
				set({left: 0, top: 0, height: "100%", width: "100%"});
				addBottom(global.statusbar);
			}
			
			qx.ui.core.ClientDocument.getInstance().add(global.mainframe);
		},
		
		/*
		 * Carga las variables de la session para la aplicacion
		 * comprueba que la session sea valida en el servidor
		 * en caso de fallo redirecciona hacia la pagina por
		 * defecto
		 *
		 */
		init_session: function() {
			qx.Class.createNamespace("global.session.id", -1);
			var session_id = lib.dao.Cookie.get_session_id();
			
			// Comprueba el tipo de la session
			var rq = this.auth_session_type(session_id);
			rq.addEventListener("ok", function(e) {
				var type = e.getData();
				if ( type == global.app.type ) {
					global.session.id = session_id;
					this.init();
				}
				else {
					lib.lang.Redirect.fallback_redirect();
				}
			}, this);
			
			rq.addEventListener("fail", function(e) {
				lib.lang.Redirect.fallback_redirect();
			});
		},
		
		/*
		 * Se sale de la aplicacion borrando las cookies y redirecciondo hacia
		 * la pagina por defecto
		 *
		 */
		quit: function() {
			this.auth_logout();
			lib.dao.Cookie.set_session_id(global.app.name, -1);
			lib.lang.Redirect.fallback_redirect();
		},
		
		// las acciones por defecto para las aplicaciones QooXdoo
		close: function(e) { this.base(arguments); },
		terminate: function(e) { this.base(arguments); }
	}
});
