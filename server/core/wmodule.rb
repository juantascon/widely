#
# Este es un ejemplo clasico de flujo de trabajo con un WModule:
# 
#  ** = WModule lo hace automaticamente 
#  * = lo hace un usuario
# 
# * Se crea una instancia de WModule
# 	** Se crea un Module con el numbre del WModule y una lista de sus dependencias
# 	** Se incluye de forma dinamica el Module en el WModule
# * Se modifica el Module agregando constantes metodos o clases
# 	** todos los cambios se reflejan automaticamente en el WModule (ya que este incluye el Module)
#	** se modifica la ruta de busqueda de bibliotecas ($:) permitiendo al modulo estar en cualquier
#      ubicacion del sistema de archivos
# * Se pide que se cargue el modulo
# 	** se expande (se incluyen las variables, clases, etc) el entorno principal (Object) con el Module
# 
# Ej:
# 
# --/dir/fs/functions.rb--
# module FS
# 	X = 3
# 	def x1
# 		"hola"
# 	end
# end
# ------------------------
#
# --/dir/fs/init.rb-------
# m = wmodule :FS => :Util do |mod|
#   require "functions.rb"
# end
# ------------------------
#
# --/main.rb--------------
# require "/dir/fs/init.rb"
#
# m.X #> 3
# m.x1 #> produce error por que es un metodo de instancia(necesita un objeto)
#      # y no de modulo(static)
# 
# m.load
# X #> 3
# x1 #> "hola"
# -------------------------

class WModule < Module
	
	#
	# La coleccion de los modulos es util para cargar varios modulos al tiempo
	#
	@@collection = Hash.new
	def self.collection(); @@collection; end
	
	
	attr_reader :name, :init_block, :creator_file, :loaded, :_module_, :depends

	#
	# :definition puede ser de la siguiente forma:
	#
	# :FS #>crea un modulo sin dependencias
	# :FS => :Util #> crea un modulo cuya unica dependecia es el modulo :Util
	# :FS => [:Util, :Network, :Kernel] #> crea un modulo con 3 dependencias
	#
	def initialize(definition,  &init_block)
		if definition.kind_of? Symbol
			@name = definition
			@depends = [ ]
		elsif definition.kind_of? Hash
			@name = definition.keys[0]
			@depends = definition.values[0]
			@depends = [@depends] if @depends.class != Array
			(@depends + [@name]).each do |d|
				raise ArgumentError.new("#{d}: invalid") if d.class != Symbol
			end
		else
			raise ArgumentError.new("#{definition}: invalid")
		end

		raise StandardError.new("WModule[#{@name}]: already exists") if @@collection[@name]
		
		# El bloque con la definicion del module
		@init_block = init_block
		raise ArgumentError.new("WModule[#{@name}]: init block not found") if ! @init_block
		
		# La ruta del archivo que creo el WModule(WModule.new) para localizar el resto de archivos
		@creator_file = caller_file(3)
		raise StandardError.new("WModule[#{@name}]: module file not found") if ! File.exist?(@creator_file)
		
		# Crea un Module vacio con el mismo nombre del WModule
		Object.module_eval("module #{@name.to_s}; end")
		
		# Localiza el modulo que se acaba de crear
		@_module_ = WModule.find_module_by_name(@name)
		
		# Incluye el nuevo Module en este WModule
		include @_module_
		
		# Incluye el nuevo Module en este WModule
		@@collection[@name] = self
		
		@loaded = false
		w_info("#{@name} -- CREATED")
	end
	
	#
	# load() se encarga de ejecutar el modulo en su propio espacio de nombre(Module)
	# y de cargar este Module en el entorno principal(Object)
	#
	def load()
		w_info("#{name} -- LOAD")
		(w_warn("#{name}: module already loaded") ; return false) if @loaded
		
		#
		# Cargar las dependencias, en caso de error aborta
		# las dependencias deben estar creadas ya
		#
		@depends.each do |m|
			mod = @@collection[m]
			if mod # El modulo existe
				# Si ya se ha cargado no hay que volverlo a hacer
				next if mod.loaded
				
				# Carga el modulo y verifica que todo salga bien
				if ! mod.load
					w_warn("#{name}: dependency module load error: #{m}")
					return false
				end
			else
				w_warn("#{name}: dependency module not found: #{m}")
				return false
			end
		end
		
		#
		# Agrega el directorio desde donde fue creado el WModule
		# en el entorno de busqueda de archivos ( $: )
		# Ejecuta el bloque del WModule y vuelve a quitar el directorio
		# del entorno de busqueda de archivos
		#
		included = true if $:.include? File.dirname(@creator_file)
		$:.unshift(File.dirname(@creator_file))
		@init_block.call(self)
		$:.remove(File.dirname(@creator_file)) if included
		
		#
		# Hace un include de este modulo desde el entorno principal (Object)
		#
		#Object.module_eval("include ObjectSpace._id2ref(#{self._module_.object_id})")
		
		@loaded = true
		w_info("#{name} -- LOADED")
		return true
	end
	
	#
	# funcion auxiliar que se encarga de buscar un Module en el
	# ObjectSpace con un nombre dado
	#
	# se utiliza despues de que se crea el Module vacio para poder
	# localizarlo e incluirlo en el WModule
	#
	def self.find_module_by_name(name)
		ObjectSpace.each_object(Module){|m| return m if m.name == name.to_s and m.class == Module}
		return nil
	end
end

#
# Con este metodo es mas comodo crear un WModule
# en lugar de WModule.new
#
module Kernel
	def wmodule(definition, &init_block)
		WModule.new(definition, &init_block)
	end
end
