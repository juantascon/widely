module Repos

class Base
	METHODS = [ :files, :create, :checkout, :status, :commit, :versions, :cat, :ls, :add, :delete, :move ]
	
	METHODS.each do |m|
		define_method(m) do |*args|
			w_warn("called abstract method: #{self.class.name}.#{method_name}")
		end
	end
end

#define el manejador por defecto y los metodos a delegar
Repository.set_manager(:default, Base)
Repository.set_methods(Base::METHODS)

end
