#
# Define un archivo de configuracion
#
class WConfig < WStorage::CentralizedStorager
	
	#
	# Define una propiedad dentro del archivo de configuracion
	#
	class Property
		
		include WStorage::Storable
		
		# El nombre de la propiedad
		attr_reader :name
		
		# El valor de la propiedad
		attr_accessor :value
		alias :collectable_key :name
		
		#
		# name: el nombre de la propiedad
		# default_value: el valor por defecto de la propiedad
		# from_storage: se carga esta propiedad desde un archivo?
		#
		def initialize(name, default_value, from_storage=false)
			@name = name
			@default_value = default_value
			
			raise wex_arg("name", @name, "(nice try)") if ! validate_id(@name)
			
			set_to_default
		end
		
		#
		# Inicializa una propiead cargada de un archivo
		#
		# data: los datos del archivo
		#
		def initialize_from_storage(data)
			name = data.keys[0]
			value = data[name]
			initialize(name, value, false)
		end
		
		#
		# Coloca el valor igual al valor por defecto
		#
		def set_to_default()
			@value = @default_value
		end
		
		#
		# Convierte la propiedad en un Hash
		#
		def to_h()
			value = @value
			value = value.to_h if value.respond_to? :to_h
			return value
		end
	end
	
	#
	# Adiciona una propiedad en la coleccion
	#
	def add_at(key, object)
		# Si la llave no existe adiciona la propiedad
		return super(key, object) if ! get(key)
		
		# Si la propiedad ya existe redefine su valor
		get(key).value = object.value
		return key
	end
	
	#
	# config_file: el archivo donde almacenar esta configuracion
	# *properties: una lista con las propiedades por defecto
	#
	def initialize(config_file, *properties)
		super(Property, config_file)
		
		properties.each{ |p| self.add(p) }
	end
	
	#
	# Restaura cada propiedad a su valor por defecto
	#
	def restore_to_default
		self.each{|p| p.restore_to_default}
	end
	
	#
	# Crea y adiciona una propiedad en la coleccion
	#
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
	WConfig::Property.new("backends", {
		"gui"=>"listener_static",
		"doc"=>"listener_static",
		"api"=>"listener_api",
		"data"=>"listener_webdav"
	}),
	WConfig::Property.new("listeners", {
		"listener_api" => {"type"=>"httpapi", "port"=>3401, "manager"=>"default"},
		"listener_static" => {"type"=>"httpstatic", "port"=>3402, "manager"=>"default"},
		"listener_webdav" => {"type"=>"webdav", "port"=>3403, "manager"=>"default_auth"}
	}))
