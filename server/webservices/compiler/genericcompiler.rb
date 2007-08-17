#
# Manejador de Compilacion Generica
#

module Compiler

class GenericCompiler < WPluginable
	
	#
	# Crea un compilador nuevo
	#
	# manager: el plugin manejador a utilizar
	#
	def initialize(manager)
		@manager = manager
		
		# Inicia el plugin indicado
		wplugin_activate(@manager)
		wplugin_init()
	end
	
end

end
