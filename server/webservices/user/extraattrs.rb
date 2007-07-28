module User
class ExtraAttrs
	
	include Singleton
	
	def initialize
		@attrs_constructors = Hash.new
		@attrs_order = Array.new
	end
	
	def add(attr_name, &constructor_block)
		raise Exception, "constructor block not given" if ! block_given?
		
		@attrs_order.push(attr_name.to_sym)
		@attrs_constructors[attr_name.to_sym] = constructor_block
	end
	
	def initialize_attrs(user, from_storage)
		@attrs_order.each do |attr_name|
			constructor_block = @attrs_constructors[attr_name]
			user.extra_attrs[attr_name] = constructor_block.call(user, from_storage)
		end
	end
	
end
end
