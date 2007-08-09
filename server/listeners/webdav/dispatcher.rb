#
# Despachador del listener WebDAV
#

module WebDav
class Dispatcher < WPluginable
	
	attr_reader :port, :server
	
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
	# data: los archivos de los usuarios
	#
	def mount_backend(backend_name)
		case backend_name
			when "data" then mount("/data/", "#{$WIDELY_DATA_DIR}/users")
			else raise Exception, "invalid backend: #{backend_name}"
		end
	end
	
end
end
