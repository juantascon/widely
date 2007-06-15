class WCollection
	
	include Enumerable
	
	attr_reader :klass, :parent, :collection
	
	def initialize(klass=Object, parent=nil)
		@klass = klass
		@parent = parent
		
		@collection = Hash.new
	end
	
	#
	# Obtiene el objeto a partir de la llave con la que se
	# almaceno, si no la encuentra retorna nil
	#
	def get(key)
		return @collection[key] if @collection.include? key
		return @parent.get(key) if @parent
		return nil
	end
	
	#
	# Obtiene el objeto a partir de la llave con la que se
	# almaceno, si no la encuentra retorna una exception
	#
	def get_ex(key, *args, &block)
		object = get(key, *args, &block)
		raise ArgumentError, "[class: #{@klass.name} key: #{key}]: object not found" if object == nil
		return object
	end
	
	#
	# Recorre la coleccion evaluando block con cada objeto y
	# cada llave ( mas info: Hash#each )
	#
	def each(*args, &block)
		@parent.each(*args, &block) if @parent
		@collection.each(*args, &block)
	end
	
	#
	# Adiciona un objeto con una llave dada
	#
	def add_at(key, object)
		return false if ! object.kind_of? @klass
		@collection[key] = object
		return key
	end
	
	#
	# Adiciona un objeto a partir de la propiedad collectable_key
	# del ojeto
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
	# Elimina un objeto de la coleccion a partir de su llave
	#
	def delete_by_key(key)
		@collection.delete(key)
		@parent.delete_by_key(key) if @parent
	end
	
	#
	# Busca y elimina un objeto de la coleccion
	#
	def delete_by_object(object)
		@collection.delete(@collection.index(object))
		@parent.delete_by_object(object) if @parent
	end
	
end
