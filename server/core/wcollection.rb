#
# Representa una coleccion de objetos
#

class WCollection
	
	include Enumerable
	
	attr_reader :klass, :parent, :collection
	
	#
	# klass: el tipo de dato que se va a almacenar en la coleccion
	# parent: si la coleccion hereda de otra coleccion
	#
	def initialize(klass=Object, parent=nil)
		@klass = klass
		@parent = parent
		
		@collection = Hash.new
	end
	
	#
	# Obtiene un objeto dado, si no la encuentra retorna nil
	#
	# key: la llave con la que se almacena el objeto 
	#
	def get(key)
		return @collection[key] if @collection.include? key
		return @parent.get(key) if @parent
		return nil
	end
	
	#
	# Obtiene un objeto dado, si no la encuentra levanta una excepcion
	#
	# key: la llave con la que se almacena el objeto
	# *args: argumentos extra para poder obtener la llave
	# block: argumento extra(closure) para poder obtener la llave
	#
	def get_ex(key, *args, &block)
		object = get(key, *args, &block)
		raise ArgumentError, "[class: #{@klass.name} key: #{key}]: object not found" if object == nil
		return object
	end
	
	#
	# Recorre la coleccion evaluando un bloque con cada objeto y
	# cada llave ( mas info: Hash#each )
	#
	# block: el bloque a evaluar
	#
	def each(*args, &block)
		@parent.each(*args, &block) if @parent
		@collection.each(*args, &block)
	end
	
	#
	# Adiciona un objeto a la coleccion
	#
	# key: la llave donde almacenar el objeto
	# object: el objeto a almacenar
	#
	def add_at(key, object)
		return false if ! object.kind_of? @klass
		@collection[key] = object
		return true
	end
	
	#
	# Adiciona un objeto a partir de la propiedad collectable_key
	# del objeto
	#
	# object: el objeto a almacenar
	#
	def add(object)
		add_at(object.collectable_key, object)
	end
	
	#
	# Crea y adiciona un objeto cuya llave es la propiedad collectable_key
	# de la clase klass pasando pasando al constructor los argumentos *args
	#
	def add_new(*args, &block)
		add(@klass.new(*args, &block))
	end
	
	#
	# Elimina un objeto de la coleccion a partir de la llave del objeto
	#
	# key: la llave donde esta el objeto
	#
	def delete_by_key(key)
		@collection.delete(key)
		@parent.delete_by_key(key) if @parent
	end
	
	#
	# Elimina un objeto de la coleccion a partir del propio objeto
	#
	# object: el objeto a eliminar
	#
	def delete_by_object(object)
		@collection.delete(@collection.index(object))
		@parent.delete_by_object(object) if @parent
	end
	
	#
	# Destruye de forma recursiva (en caso de que se pueda) todos los objetos de la
	# coleccion
	#
	def destroy()
		each do |key, obj|
			obj.destroy if obj.respond_to? :destroy
		end
	end
	
end
