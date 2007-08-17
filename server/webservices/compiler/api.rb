#
# API de Compiler
#

module Compiler

class API
	
	include Singleton
	include WebService
	
	#
	# Retorna la lista de posibles compiladores
	#
	def manager_list(args)
		args.check("session_id")
		session = Auth::SessionSet.instance.get_ex(args["session_id"])
		return true, GenericCompiler.wplugin_list
	end
	
	#
	# Compila un archivo fuente
	#
	def compile(args)
		args.check("session_id", "manager", "path")
		
		wc = Auth::SessionSet.instance.get_ex(args["session_id"]).wc
		
		manager = args["manager"]
		path = args["path"]
		
		compiler = GenericCompiler.new(manager)
		
		return compiler.compile(wc, path)
	end
	
end

# Registra este API como un webservice
HTTPAPI::WebServiceHandler.set_webservice("compiler", Compiler::API.instance)

end
