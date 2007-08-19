/*
 * API de compiler en el lado cliente
 *
 * para mas informacion consultar server/webservices/compilr
 *
 */
qx.Mixin.define("lib.dao.api.Compiler",
{
	members:
	{
		compiler_manager_list: function() {
			return ( new lib.dao.WRQ("compiler", "manager_list",
				{ "session_id": global.session.id },
				"Get Manager List") );
		},
		
		compiler_compile: function(manager, path) {
			return ( new lib.dao.WRQ("compiler", "compile",
				{ "session_id": global.session.id, "manager": manager, "path": path },
				"Compile") );
		}
	}
});
