module FS
class Repository
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

#define el manejador por defecto y los metodos a delegar
set_manager(:default, Base)
Base::METHODS.each { |m| @@forward_methods.push m.to_sym }

end
end
