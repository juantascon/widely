#
# Despachador del listener HTTPAPI
#

module HTTPAPI
class Dispatcher < WPluginable
	
	attr_reader :port
	
	#
	# Inicia el servidor
	#
	# port: el puerto en el que iniciar el servidor
	# manager: el plugin encargado de manejar el servidor
	#
	def initialize(port, manager)
		@port = port
		
		wplugin_activate(manager)
		wplugin_init()
	end
	
	#
	# Monta un backend permitido puede ser:
	#
	# api: los webservices disponibles
	#
	def mount_backend(backend_name)
		case backend_name
			when "api" then mount("/api/") { |rq| WebServiceHandler.process_rq(rq) }
			else raise Exception, "invalid backend: #{backend_name}"
		end
	end
	
end
end
