class Collection
	
	include Enumerable
	
	attr_reader :collection, :parent
	
	def initialize(parent=nil)
		@collection = Hash.new
		@parent = parent
	end
	
	def get(key)
		return @collection[key] if @collection.include? key
		return @parent.get(key) if @parent
		return nil
	end
	
	def get_ex(key, *args, &block)
		object = get(key, *args, &block)
		raise ArgumentError, "#{@collection.class.name}[#{key}]: collectable object not found" if object == nil
		return object
	end
	
	def each(*args, &block)
		@collection.each(*args, &block)
		@parent.each(*args, &block) if @parent
	end
	
	def add_at(key, object)
		@collection[key] = object
		return key
	end
	
	def add(object)
		add_at(object.collectable_key, object)
	end
	
	def add_new(klass, *args)
		add(klass.new(*args))
	end
	
	def delete_by_key(key)
		@collection.delete(key)
		@parent.delete_by_key(key) if @parent
	end
	
	def delete_by_object(object)
		@collection.delete(@collection.index(object))
		@parent.delete_by_object(object) if @parent
	end
	
end
