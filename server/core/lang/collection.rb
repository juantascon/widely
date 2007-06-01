class Collectable
	
	attr_reader :object, :name, :collection
	
	def initialize(object, name)
		@object = object
		@name = name
	end
	
	def collect(collection)
		@collection = collection
		@name
	end
	
	def uncollect(collection)
		@collection = nil
		@name
	end
	
	def to_s
		return "#{@object.class.name} ( #{@name} )"
	end
	
end


class Collection
	
	include Enumerable
	
	attr_reader :collection, :parent
	
	def initialize(parent=nil)
		@collection = Hash.new
		@parent = parent
	end
	
	def get(name)
		return @collection[name] if @collection.include? name
		return @parent.get(name) if @parent
		return nil
	end
	
	def get_ex(name, *args, &block)
		object = get(name, *args, &block)
		raise ArgumentError, "#{name}: collectable not found  #{@collection}" if object == nil
		return object
	end
	
	def each(*args, &block)
		@collection.each(*args, &block)
	end
	
	def add(object)
		name = object.collectable.collect(self)
		@collection[name] = object
		return name
	end
		
	def delete(name)
		object = @collection.delete(name)
		object.collectable.uncollect(self)
		return object
	end
	
end
