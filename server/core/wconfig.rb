module WConfig

class ConfigSet < Collection
	def initialize
		super
	end
end

class Property
	
	attr_reader :name, :default_value, :value
	alias :collectable_key :name
	
	def initialize(name, default_value)
		self.set_value(default_value)
		
		@name = name
		@default_value = default_value
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

class EnumProperty < Property
	
	attr_reader :options
	
	def initialize(name, default_value, options=nil)
		options = Array.new if ! options.kind_of? Array
		@options = options
		super(name, default_value)
	end
	
	def set_value(value)
		raise ArgumentError, "#{value}: invalid value" if ! @options.include? value
		super(value)
	end
	
end


class StringProperty < Property
	
	def set_value(value)
		super(value.to_s)
	end
	
	def get_value()
		super().gsub(/%[a-zA-Z0-9_\.]+%/) { |s| $CONFIG.get([s.gsub("%", "")]) }
	end
	
end


class NumericProperty < Property
	
	attr_reader :range_begin, :range_end
	
	def set_value(value, range_begin=0, range_end=(2**16)-1)
		@range_begin = range_begin
		@range_end = range_end
		raise ArgumentError, "#{value}: invalid value" if ! value.respond_to? :to_i
		raise ArgumentError, "#{value}: invalid value" if ! value.between?(@range_begin, @range_end)
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
