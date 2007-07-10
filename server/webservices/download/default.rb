module Download

class Default
	METHODS = [ :pack ]
	
	METHODS.each do |m|
		define_method(m) do |*args|
			w_warn("called abstract method: #{self.class.name}.#{method_name}")
		end
	end
end

#define el manejador por defecto
Download.register_wplugin(WPlugin.new("default",  "Default Download Plugin",Default))

end
