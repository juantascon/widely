module FS
class Repository < ForwardManager
	
	#
	# Registra esta clase como WebService
	#
	extend WebService
	webservice("repos")
	webservice_module_method :new
	
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
	# Parametros de ForwardManager
	#
	Repository.set_default_manager(Base)
	Repository.set_methods(Base::METHODS)
	
	#
	# Crea un nuevo objeto dependiendo del manejador a utilizar
	#
	def initialize(manager_name=:default, *args)
		webservice_object()
		forward(manager_name, *args)
	end
	
end
end

