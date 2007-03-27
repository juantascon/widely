# Este es un ejemplo clasico de flujo de trabajo con un WModule:
# 
#  ** = WModule lo hace automaticamente 
#  * = lo hace un usuario
# 
# * Se crea una instancia de WModule
# 	** Se crea un Module con el numbre del WModule
# 	** Se incluye de forma dinamica el Module en el WModule
# * Se modifica el Module agregando constantes metodos o clases
# 	** todos los cambios se reflejan automaticamente en el WModule (ya que este incluye el Module)
#	** se modifica la ruta de busqueda de bibliotecas ($:) permitiendo al modulo estar en cualquier ubicacion
# * Se pide que se cargue el modulo
# 	** se expande(se incluyen las variables, clases, etc) el entorno principal (Object) con el Module
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
# m = WModule.new("FS") { |mod| require "functions.rb" }
# ------------------------
#
# --/main.rb--------------
# require "/dir/fs/init.rb"
#
# m.X #> 3
# m.x1 #> produce error por que los metodos de modulo no se heredan
#      #>  y los metodos de instancia no se pueden llamar desde el modulo
# 
# m.load
# X #> 3
# x1 #> "hola"
# -------------------------

class WModule < Module
	
	module STATUS
		CREATED = 0
		STARTED = 1
		LOADED = 2
	end
	
	include STATUS
	
	@@collection = Hash.new
	@@last = nil
	
	def self.collection(); @@collection; end
	def self.last(); @@last; end
	
	attr_reader :name, :init_block, :creator_file, :status, :_module_
	
	def initialize(name, &init_block)
		@name = name
		raise we_error("#{name}", "module already exists") if @@collection[@name]
		
		@init_block = init_block
		raise we_error("#{name}", "init block not found") if ! @init_block
		
		@creator_file = caller_file(1) # El archivo que invoca WModule.new()
		raise we_error("#{@name}", "cannot find the module file") if ! File.exist?(@creator_file)
		
		Object.module_eval("module #{@name}; end") # Crea un modulo vacio con el nombre del modulo
		@_module_ = WModule.find_module_by_name(@name) # Busca el nuevo modulo creado
		include @_module_ # Expande este modulo con el nuevo modulo
		
		@@collection[@name] = self
		@@last = self
		
		@status = CREATED
		w_debug("#{@name} -- CREATED")
	end
	
	def start()
		w_info("#{name} -- START")
		w_warn("#{name}: invalid status: #{@status}") if @status != CREATED
			
		included = true if $:.include? File.dirname(@creator_file)
		$: << (File.dirname(@creator_file))
		@init_block.call(self)
		$:.remove(File.dirname(@creator_file)) if included
		
		@status = STARTED
		w_info("#{name} -- STARTED")
	end
	
	# Hace un include desde el modulo Object de este modulo
	# con esto Object(el namespace global) incluira este modulo
	def load(force=false)
		w_info("#{name} -- LOAD")
		w_warn("#{name}: invalid status: #{@status}") if @status != STARTED
		
		Object.module_eval("include ObjectSpace._id2ref(#{self.object_id})")
		
		@status = LOADED
		w_info("#{name} -- LOADED")
	end
	
	def self.find_module_by_name(name)
		ObjectSpace.each_object(Module){|m| return m if m.name == name and m.class == Module}
		nil
	end
end
