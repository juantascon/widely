# Esta clase es solo una clase abstracta de las que los modulos
# de manejo de versiones (ej: cvs, svn, git, etc) deben heredar
# y redefinir estos metodos

module FS
class Repository
	class Base
		METHODS = [ :files, :create, :checkout, :status, :commit, :versions, :cat, :ls, :add, :delete, :move ]
		
		METHODS.each do |m|
		 	define_method(m) do |*args|
		 		w_warn("called abstract method: #{self.class.name}.#{method_name}")
		 	end
		end
	end
	Repository.set_default_manager(Base)
	Repository.set_methods(Base::METHODS)
end
end
