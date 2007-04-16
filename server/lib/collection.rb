class Collection
	
	#
	# Inicia la coleccion de objetos
	#
	def initialize
		@__objects__ = Array.new
	end
	
	#
	# Registra un objeto dentro del array de objetos
	#
	def save_o(instance)
		id = @__objects__.push(instance).length - 1
		return id
	end
	
	#
	# Obtiene un objeto del array de objetos
	#
	def get_o(id)
		begin
			return @__objects__[id.to_i] if @__objects__[id.to_i]
		rescue
			return nil
		end
		return nil
	end
end
