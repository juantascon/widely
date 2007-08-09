#
# Datos extra por cada usuario ej: una coleccion de repositorios
#

module User
class ExtraAttrs
	
	include Singleton
	
	def initialize
		# Los constructores de los datos extra
		@attrs_constructors = Hash.new
		
		# El orden en que se deben crear los datos extra
		@attrs_order = Array.new
	end
	
	#
	# Adiciona un atributo extra a los usuarios
	#
	# attr_name: el nombre del atributo
	# constructor_block: el bloque constructor del atributo
	#
	def add(attr_name, &constructor_block)
		raise Exception, "constructor block not given" if ! block_given?
		
		@attrs_order.push(attr_name.to_sym)
		@attrs_constructors[attr_name.to_sym] = constructor_block
	end
	
	#
	# Crea los datos extra en un usuario
	#
	# user: el usuario donde crear el dato extra
	#
	def initialize_attrs(user, from_storage)
		@attrs_order.each do |attr_name|
			constructor_block = @attrs_constructors[attr_name]
			user.extra_attrs[attr_name] = constructor_block.call(user, from_storage)
		end
	end
	
end
end
