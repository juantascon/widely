module FS
class Repository < WebService
	
	# Registra esta clase como WebService
	webservice("repos")
	
	#
	# Identifica una version dentro de un repositorio
	#
	class Version
		attr_reader :id, :description, :date, :author
		
		def initialize(id, description = "", date = nil, author = "")
			@id = id
			@description = description
			@date = date
			@author = author
		end
		
		def get
			id.to_s
		end
	end
	
	#
	# Esta clase es solo una clase abstracta de las que los modulos
	# de manejo de versiones (ej: cvs, svn, git, etc) deben heredar
	# y redefinir estos metodos
	#
	class Base
		METHODS = [ :files, :create, :checkout, :status, :commit, :versions, :cat, :ls, :add, :delete, :move ]
		
		METHODS.each do |m|
		 	define_method(m) do |*args|
		 		w_warn("called abstract method: #{self.class.name}.#{method_name}")
		 	end
		end
	end
	
	#
	# Esta clase realmente sirve para delegar los llamados
	# a otras clases manejadoras de versiones
	#
	
	# Lista de manejadores y metodos para delegar
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
	
	#define el manejador por defecto y los metodos a delegar
	set_manager(:default, Base)
	Base::METHODS.each { |m| @@forward_methods.push m.to_sym }
	
	#
	# Crea un nuevo objeto dependiendo del manejador a utilizar
	# en caso de fallo utiliza el manejador por defecto
	#
	webservice_module_method :new
	def initialize(manager_name=:default, *args)
		webservice_object()
		
		# Crea la instancia del manejador
		begin
			@instance = @@forward_managers[manager_name].new(*args)
		rescue
			# Si no se puede crear el manejar utiliza uno por defecto
			w_warn("#{manager_name}: manager not found, using default")
			manager_name = :default
			retry
		end
		
		# Hace el forward de los metodos por medio de la biblioteca Forwardable
		self.extend SingleForwardable
		@@forward_methods.each { |m| self.def_delegator :@instance, m }
	end
	
end
end

