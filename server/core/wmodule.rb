#Todo: mejorar el flujo de la carga de dependencias(load)
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
# m = wmodule :FS => :Util do
#   |mod| require "functions.rb"
# end
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
	@@collection = Hash.new
	def self.collection(); @@collection; end
	
	attr_reader :name, :init_block, :creator_file, :loaded, :_module_, :depends
	
	def initialize(definition,  &init_block)
		if definition.kind_of? Symbol
			@name = definition
			@depends = [ ]
		elsif definition.kind_of? Hash
			@name = definition.keys[0]
			@depends = definition.values[0]
			@depends = [@depends] if @depends.class != Array
			(@depends + [@name]).each do |d|
				raise we_error("WModule", "Argument error: #{d}") if d.class != Symbol
			end
		else
			raise we_error("WModule", "Argument error: #{definition}")
		end

		raise we_error("#{name}", "module already exists") if @@collection[@name]
		
		@init_block = init_block
		raise we_error("#{name}", "init block not found") if ! @init_block
		
		@creator_file = caller_file(2) # El archivo que invoca WModule.new()
		raise we_error("#{@name}", "cannot find the module file") if ! File.exist?(@creator_file)
		
		Object.module_eval("module #{@name.to_s}; end") # Crea un modulo vacio con el nombre del modulo
		@_module_ = WModule.find_module_by_name(@name) # Busca el nuevo modulo creado
		include @_module_ # Expande este modulo con el nuevo modulo
		
		@@collection[@name] = self
		
		@loaded = false
		w_debug("#{@name} -- CREATED")
	end
	
	def load()
		w_info("#{name} -- LOAD")
		(w_warn("#{name}: module already loaded") ; return false) if @loaded
		
		#Cargar las dependencias, en caso de error abortar
		@depends.each do |m|
			mod = @@collection[m]
			if mod
				if mod.loaded
					next
				else
					if ! mod.load
						w_warn("#{name}: dependency module load error: #{m}")
						return false
					end
				end
			else
				w_warn("#{name}: dependency module not found: #{m}")
				return false
			end
		end
		
		included = true if $:.include? File.dirname(@creator_file)
		$: << (File.dirname(@creator_file))
		@init_block.call(self)
		$:.remove(File.dirname(@creator_file)) if included
		
		# Hace un include desde el modulo Object de este modulo
		# con esto Object(el namespace global) incluira este modulo
		Object.module_eval("include ObjectSpace._id2ref(#{self._module_.object_id})")
		
		@loaded = true
		w_info("#{name} -- LOADED")
		return true
	end
	
	def self.find_module_by_name(name)
		ObjectSpace.each_object(Module){|m| return m if m.name == name.to_s and m.class == Module}
		return nil
	end
end

module Kernel
	def wmodule(definition, &init_block)
		WModule.new(definition, &init_block)
	end
end
