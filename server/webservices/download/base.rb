module Download

class Base
	METHODS = [ :pack ]
	
	METHODS.each do |m|
		define_method(m) do |*args|
			w_warn("called abstract method: #{self.class.name}.#{method_name}")
		end
	end
end

#define el manejador por defecto y los metodos a delegar
Download.set_manager(:default, Base)
Download.set_methods(Base::METHODS)

end
