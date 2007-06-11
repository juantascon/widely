module UserData
class UserData
	
	attr_reader :key, :value
	alias :collectable_key :key
	
	def initialize(key, value)
		@key = key
		@value = value
	end
	
	def to_h()
		{ "key" => @key, "value" => @value }
	end
	
	def load(data)
		@key = data["key"]
		@value = data["value"]
	end
	
end
end