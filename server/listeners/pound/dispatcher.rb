#
# Despachador del listener principal Pound 
#

module Pound
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
	
end
end
