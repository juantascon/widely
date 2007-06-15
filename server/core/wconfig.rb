class WConfig < WStorage::CentralizedStorager
	
	class Property
		
		include WStorage::Storable
		
		attr_reader :name, :default_value
		attr_accessor :value
		alias :collectable_key :name
		
		def initialize(name, default_value, from_storage=false)
			@name = name
			@default_value = default_value
			
			set_to_default
		end
		
		def initialize_from_storage(data)
			name = data["name"]
			default_value = data["default_value"]
			value = data["value"]
			
			initialize(name, default_value, false)
			self.value = value
		end
		
		def set_to_default()
			self.value = @default_value
		end
		
		def to_h()
			default_value = @default_value
			value = @value
			
			default_value = @default_value.to_h if @default_value.respond_to? :to_h
			value = @value.to_h if @value.respond_to? :to_h
			
			return { "name" => @name, "default_value" => default_value, "value" => value }
		end
	end
	
	def initialize(config_file, *properties)
		super(Property, config_file)
		
		properties.each{ |p| self.add(p) }
	end
	
	def restore_to_default
		self.each{|p| p.restore_to_default}
	end
	
	def add_property(name, default_value)
		self.add(Property.new(name, default_value))
	end
	
end

#
# Inicia la configuracion Global
#
$CONF = WConfig.new("#{$WIDELY_DATA_DIR}/widely.conf")
