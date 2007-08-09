#
# Despachador del listener HTTPStatic
#

module HTTPStatic
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
	# gui: la interfaz grafica
	# doc: la documentacion del sistema
	#
	def mount_backend(backend_name)
		case backend_name
			when "gui" then mount("/gui/", $WIDELY_HOME_GUI)
			when "doc" then mount("/doc/", $WIDELY_HOME_DOC)
			else raise Exception, "invalid backend: #{backend_name}"
		end
	end
	
end
end
