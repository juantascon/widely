# Ayuda a hacer forward de llamados a metodos utilizando
# manejadores que deben registrar su servicio

class ForwardManager
	
	@@managers = Hash.new
	@@methods = Array.new
	def self.set_manager(name, manager)
		if name.kind_of? Symbol and manager.kind_of? Class
			@@managers[name] = manager
		else
			w_warn("#{name}:#{manager} manager not added")
			return false
		end
	end
	
	def self.set_default_manager(manager)
		set_manager(:default, manager)
	end

	def self.set_methods(methods)
		methods.each do |m|
			@@methods.push m.to_sym
		end
	end
	
	attr :instance
	def forward(manager_name=:default, *args)
		if @@managers[manager_name].kind_of? Class
			@instance = @@managers[manager_name].new(*args)
		else
			w_warn("#{manager_name}: manager not found, using default")
			@instance = @@managers[:default].new(*args)
		end
		self.extend SingleForwardable
		@@methods.each {|m| self.def_delegator :@instance, m}
	end
	
end
