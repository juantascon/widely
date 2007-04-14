module FS
class Repository
	#
	# Esta clase realmente sirve para delegar los llamados
	# a otras clases manejadoras de versiones
	#
	
	# Lista de manejadores y metodos a delegar
	@@forward_managers = Hash.new
	@@forward_methods = Array.new
	
	#
	# define un manejador para un indentificador dado
	#
	def self.set_manager(name, manager)
		if name.kind_of? Symbol and manager.kind_of? Class
			@@forward_managers[name] = manager
		else
			w_warn("#{name}:#{manager} manager not added")
			return false
		end
	end
	
	#
	# Crea un nuevo objeto dependiendo del manejador a utilizar
	# en caso de fallo utiliza el manejador por defecto
	#
	def initialize(manager, *args)
		# Crea la instancia del manejador
		begin
			@instance = @@forward_managers[manager_name].new(*args)
		rescue
			# Si no se puede crear el manejar utiliza uno por defecto
			w_warn("#{manager_name}: manager not found, using default")
			@instance = @@forward_managers[:default].new()
		end
		
		# Hace el forward de los metodos por medio de la biblioteca Forwardable
		self.extend SingleForwardable
		@@forward_methods.each { |m| self.def_delegator :@instance, m }
	end
	
end
end
