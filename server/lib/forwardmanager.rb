#
# Ayuda a hacer forward de llamados a metodos de otras clases
# utilizando manejadores que deben registrar su servicio
#
class ForwardManager
	
	#
	# Las colecciones de los manejadores y los metodos
	# que se les deben hacer forward
	#
	@@forward_managers = Hash.new
	@@forward_methods = Array.new
	
	#
	# Define una clase manejadora con un identificador
	#
	def self.set_manager(name, manager)
		if name.kind_of? Symbol and manager.kind_of? Class
			@@managers[name] = manager
		else
			w_warn("#{name}:#{manager} manager not added")
			return false
		end
	end
	
	#
	# Define la clase manejadora por defecto
	#
	def self.set_default_manager(manager)
		set_manager(:default, manager)
	end
	
	#
	# Agrega los metodos que se deben hacer forward
	#
	def self.set_methods(methods)
		methods.each do |m|
			@@methods.push m.to_sym
		end
	end
	
	#
	# Hace Forward de los metodos a una instancia del
	# manejador indicado
	#
	attr :instance
	def forward(manager_name=:default, *args)
		if @@managers[manager_name].kind_of? Class
			# Crea la instancia del manejador
			@instance = @@managers[manager_name].new(*args)
		else
			w_warn("#{manager_name}: manager not found, using default")
			@instance = @@managers[:default].new(*args)
		end
		
		# Hace el forward de los metodos por medio de la biblioteca Forwardable
		self.extend SingleForwardable
		@@methods.each {|m| self.def_delegator :@instance, m}
	end
	
end
