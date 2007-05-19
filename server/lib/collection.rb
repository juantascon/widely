class Collection
	
	#
	# Inicia la coleccion de objetos
	#
	def initialize
		@__objects__ = Hash.new
	end
	
	#
	# Registra un objeto en la coleccion
	#
	def save_o(obj)
		@__objects__[obj.collectable_id.to_s] = obj
		return obj.collectable_id.to_s
	end
	
	#
	# Obtiene un objeto de la coleccion(nil si no lo encuentra)
	#
	def get_o(id)
		@__objects__[id.to_s]
	end
	
	#
	# Borra un objeto de la coleccion
	#
	def delete_o(id)
		@@__objects__.delete(id.to_s)
	end
	
end
