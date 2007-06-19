class WConfig < WStorage::CentralizedStorager
	
	class Property
		
		include WStorage::Storable
		
		attr_reader :name
		attr_accessor :value
		alias :collectable_key :name
		
		def initialize(name, default_value, from_storage=false)
			@name = name
			@default_value = default_value
			
			raise wex_arg("name", @name, "(nice try)") if ! validate_id(@name)
			
			set_to_default
		end
		
		def initialize_from_storage(data)
			name = data.keys[0]
			value = data[name]
			initialize(name, value, false)
		end
		
		def set_to_default()
			@value = @default_value
		end
		
		def to_h()
			value = @value
			value = value.to_h if value.respond_to? :to_h
			return value
		end
	end
	
	def add_at(key, object)
		return super(key, object) if ! get(key)
		get(key).value = object.value
		return key
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

#
# Inicia la configuracion de los listeners
#
$CONF_LISTENERS = WConfig.new("#{$WIDELY_DATA_DIR}/listeners.conf",
	WConfig::Property.new("main", { "port"=>7777, "manager"=>"default" }),
	WConfig::Property.new("backends",
		{ "qooxdoo"=>"listener_static",
		"gui"=>"listener_static",
		"doc"=>"listener_static",
		"api"=>"listener_api",
		"data"=>"listener_webdav"}),
	WConfig::Property.new("listeners",
		{ "listener_api" => {"type"=>"httpapi", "port"=>3401, "manager"=>"default"},
		"listener_static" => {"type"=>"httpstatic", "port"=>3402, "manager"=>"default"},
		"listener_webdav" => {"type"=>"webdav", "port"=>3403, "manager"=>"default_auth"}}))
