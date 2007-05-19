#
# Esta clase sirve para delegar los llamados
# a otras clases manejadoras
#

module DynamicDelegator
	
	def self.included(base)
		base.class_eval do
			
			include ClassAttr
			
			# Lista de manejadores y metodos a delegar
			class_attr :__forward_managers, :__forward_methods
			@__forward_managers = Hash.new
			@__forward_methods = Array.new
			
			#
			# define un manejador para un indentificador dado
			#
			def self.set_manager(name, manager)
				if name.kind_of? Symbol and manager.kind_of? Class
					self.__forward_managers[name] = manager
				else
					w_warn("#{name}:#{manager} manager not added")
					return false
				end
			end
			
			def self.get_manager(id)
				self.__forward_managers[id]
			end
			
			def self.add_method(m)
				self.__forward_methods.push(m.to_sym)
			end
			
			def self.set_methods(ms)
				self.__forward_methods.replace(ms)
			end
		end
	end
	
	# El manejador para la instancia actual
	attr_reader :manager
	
	def start_forward()
		# Hace el forward de los metodos por medio de la biblioteca Forwardable
		self.extend SingleForwardable
		self.class.__forward_methods.each { |m| self.def_delegator :@manager, m }
	end
end
