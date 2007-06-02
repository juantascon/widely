module WConfig

class ConfigSet < Collection
	def initialize
		super
	end
end

class Property
	
	attr_reader :name, :init_value, :value
	alias :collectable_key :name
	
	def initialize(name, init_value)
		self.set_value(init_value)
		
		@name = name
		@init_value = init_value
	end
	
	def set_value(value)
		@value = value
	end
	
	def get_raw_value()
		@value
	end
	
	def get_value()
		get_raw_value()
	end
end


class StringProperty < Property
	
	def set_value(value)
		raise ArgumentError, "#{value}: invalid value" if ! value.respond_to? :to_s
		super(value.to_s)
	end
	
	def get_value()
		super().gsub(/%[a-zA-Z0-9_\.]+%/) { |s| $CONFIG.get([s.gsub("%", "")]) }
	end
	
end


class NumericProperty < Property
	
	def set_value(value)
		raise ArgumentError, "#{value}: invalid value" if ! value.respond_to? :to_i
		super(value.to_i)
	end
	
end


class BooleanProperty < Property
	
	def set_value(value)
		value ? super(true) : super(false)
	end
	
end

end

#
# Inicia la configuracion Global
#
$CONFIG = WConfig::ConfigSet.new
