#
# Provee la funcionalidad de almacenamiento persistente
#

module WStorage

#
# Los metodos comunes para clases que se pueden almacenar
#

module Storable
	
	#
	# Llamado cuando se incluye este modulo en una clase o en otro modulo
	#
	def Storable.included(mod)
		class << mod
			
			#
			# Crea un objeto a partir de su representacion en un archivo
			#
			# data: los datos extras a pasar al constructor del objeto
			# config_file: la ruta del archivo donde se almacena el objeto
			#
			def new_from_storage(data, config_file)
				data_dir = File.cleanpath("#{File.dirname(config_file)}/data_dir")
				
				# Se crea la nueva instancia
				obj = allocate
				
				# En este momento solo este hilo debe estarse ejecutando
				Thread.critical = true
				
				#
				# Se define de forma temporal un metodo que permita definir las variables
				# config_file y data_dir de la nueva instancia
				#
				class << obj
					def set_storage_paths(config_file, data_dir)
						@config_file = config_file
						@data_dir = data_dir
					end
				end
				
				# Se definen las variables en el nuevo objeto
				obj.set_storage_paths(config_file, data_dir)
				
				# Se elimina el metodo que se ha creado en el objeto
				class << obj
					undef_method :set_storage_paths
				end
				
				# En este momento otros hilos pueden estarse ejecutando
				Thread.critical = false
				
				# Inicializa el objeto
				obj.initialize_from_storage(data)
				
				return obj
			end
			
		end
	end
	
	#
	# Este metodo debe ser redefinido en las clases que se pueden almacenar
	# para inicializar el objeto desde los datos almacenados
	#
	def initialize_from_storage(data)
	end
	
	#
	# Comprueba que el identificador del objeto este bien definido para
	# evitar problemas cuando el id contenga simbolos no admitidos como
	# nombre de archivo validos
	#
	# id: el identificador a comprobar
	#
	def validate_id(id)
		return false if ! id.kind_of? String
		
		#
		# Unicamente se permiten: 
		# 1. letras
		# 2. numeros
		# 3. el simbolo "_"
		# 4. el simbolo "-"
		#
		regexp = /[a-zA-Z][a-zA-Z0-9_-]*/
		return false if ! regexp === id
		return false if ! regexp.match(id)[0] == id
		
		return true
	end
	
	#
	# Este metodo se debe redefinir en cada clase que se pueda almacenar para
	# sacar la informacion que se quiere almacenar
	#
	def to_h()
		{ "object_id" => self.object_id  }
	end
	
end


#
# Modulo con metodos comunes entre los almacenadores
#

module Storager
	
	#
	# Carga un objeto desde un archivo
	#
	# filename: el nombre del archivo a cargar
	#
	def load_from_file(filename)
		begin
			file = File.new(filename)
			
			# Los datos se almacenan en formato YAML
			data = YAML::load(file)
			file.close
			
			return data
		rescue Exception => ex
			w_info("Imposible to load from file: #{filename}")
			w_debug(ex)
			return false
		end
	end
	
	#
	# Guarda un objeto en un archivo
	#
	# filename: el nombre del archivo
	# data: los datos del objeto
	#
	def save_to_file(filename, data)
		begin
			# Se crea el archivpo y sus directorios padre
			FileUtils.mkdir_p(File.dirname(filename))
			file = File.new(filename, "w+")
			
			YAML::dump(data, file)
			file.close
			
			return true
		rescue Exception => ex
			w_info("Imposible to save to file: #{filename}")
			w_debug(ex)
			return false
		end
	end
	
end

#
# Permite almacenar de forma distribuida una coleccion de archivos
# cada objeto de la coleccion se almacena en un archivo diferente
#

class DistributedStorager < WCollection
	
	include Storager
	
	attr_reader :path_format
	
	#
	# klass: el tipo de dato a almacenar
	# path_format: un formato estandar para almacenar cada archivo, el simbolo %s
	# se reemplazara con la llave del archivo a almacenar ej: "/etc/%s.conf"
	# parent: en caso de que la coleccion descienda de otra
	#
	def initialize(klass=Object, path_format="", parent=nil)
		@path_format = path_format
		raise wex_arg("path_format", @path_format) if (@path_format.scan("%s").size != 1)
		
		super(klass, parent)
	end
	
	#
	# Adiciona el objeto en la coleccion y ademas lo guarda en el archivo
	#
	def add_at(key, object)
		raise wex_arg("key", key, "(nice try)") if (key.include? "/" || key[0..0] == ".")
		
		# Adiciona el objeto a la coleccion
		ret = super(key, object)
		
		# Almacena el objeto en un archivo
		save(key)
		
		return ret
	end
	
	#
	# Carga un objeto desde un archivo
	#
	# key: la llave del objeto
	#
	def load(key)
		begin
			# La ruta calculada para guardar el archivo 
			filename = @path_format % key
			
			# Carga los datos del archivo
			data = load_from_file(filename)
			return false if ! data
			
			# Crea el objeto a partir de los datos
			object = @klass.new_from_storage(data, filename)
			
			# Adiciona el nuevo objeto a la coleccion
			self.add(object)
			
			return true
		rescue Exception => ex
			w_info("Invalid Config File: #{filename}")
			w_debug(ex)
			return false
		end
	end
	
	#
	# Guarda un objeto en un archivo
	#
	# key: la llave del objeto
	#
	def save(key)
		# Obtiene el objeto de la coleccion
		object = get(key)
		return false if ! object
		
		# La ruta calculada para guardar el archivo 
		filename = @path_format % key
		
		# Los datos del objeto
		data = object.to_h
		
		# Almacena los datos del objeto en el archivo
		return save_to_file(filename, data)
	end
	
	#
	# Carga de forma recursiva desde todos los archivos que sean
	# compatibles con path_format 
	#
	def load_all()
		Dir.glob(@path_format % "*").each do |filename|
			key = Regexp.new(@path_format % "(.*)").match(filename)[1]
			w_info("Not loaded #{@klass.name}: #{key}") if ! load(key)
		end
	end
	
	#
	# Almacena de forma recursiva todos los objetos de la coleccion
	#
	def save_all()
		self.each do |key, object|
			save(key)
		end
	end
	
end


#
# Almacenamiento centralizado
# Todos los objetos se almacenan en el mismo archivo
#

class CentralizedStorager < WCollection
	
	include Storager
	
	attr_reader :config_file
	
	#
	# klass: el tipo de dato a almacenar
	# config_file: la ruta del archivo para almacenar los objetos
	# parent: en caso de que la coleccion herede de otra
	#
	def initialize(klass=Object, config_file="", parent=nil)
		@config_file = config_file
		super(klass, parent)
	end
	
	#
	# Carga todos los objetos del archivo
	#
	def load_all()
		begin
			
			# Los datos del archivo
			data = load_from_file(@config_file)
			return false if ! data
			
			#
			# Los datos deben estar en forma de hash donde cada llave representa
			# la llave de un elemento y donde cada valor representa un objeto
			#
			data.each do |key, value|
				# Carga el objeto con los datos almacenados
				object = @klass.new_from_storage({key => value}, @config_file)
				
				# Adiciona el objeto en la coleccion
				self.add(object)
			end
			
			return true
		rescue Exception => ex
			w_info("Invalid Config File: #{@config_file}")
			w_debug(ex)
			return false
		end
	end
	
	#
	# Guarda todos los objetos en el archivo
	#
	def save_all()
		data = Hash.new
		
		#
		# Se debe almacenar en un hash donde cada elemento es de la forma:
		# { llave_objeto => objeto }
		#
		self.each { |key, object| data[key] = object.to_h }
		
		# Se guarda el archivo
		save_to_file(@config_file, data)
	end
	
end

end
