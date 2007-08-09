#
# Un Wplugin es objeto que posee una clase o un modulo que redefine los metodos o atributos
# de otra clase
#

class WPlugin
	
	attr_reader :name, :description, :definition, :instance
	
	#
	# name: el nombre del plugin
	# description: la descripcion del plugin
	# definition: la clase donde se definen los nuevos metodos
	#
	def initialize(name, description, definition)
		@name = name
		@description = description
		@definition = definition
	end
	
	#
	# Activa el plugin
	#
	# wpluginable: el pluginable donde activar este plugin
	#
	def activate(wpluginable, *args, &block)
		case @definition.class.name
			
			# El plugin tiene un clase
			when "Class"
				wpluginable.extend SingleForwardable
				@instance = @definition.new(wpluginable, *args, &block)
				
				methods = ( @definition.instance_methods - Object.instance_methods )
				methods.each do |m|
					wpluginable.def_delegator("@instance", m.to_sym, m.to_sym)
				end
				
			# El plugin tiene un modulo
			when "Module"
				wpluginable.extend @definition
				
			else
				raise StandardError, "#{@definition}: invalid definition"
				
		end
	end
	
	#
	# Convierte la informacion del plugin en un Hash
	#
	def to_h()
		return { "name" => @name, "description" => @description }
	end
	
end


#
# Un WPluginable es la interfaz que permite que un wplugin redefina sus metodos
# o atributos
#

class WPluginable
	
	class_inheritable_accessor :wplugins
	self.wplugins = Hash.new
	
	#
	# Registra un plugin
	#
	# wplugin: el plugin a registrar
	#
	def self.register_wplugin(wplugin)
		# Ya existe un plugin con ese nombre?
		return false if self.wplugins[wplugin.name]
		
		# Almacena el plugin
		self.wplugins[wplugin.name] = wplugin
		
		return true
	end
	
	#
	# Retorna la lista de plugins disponibles para este pluginable
	#
	def self.wplugin_list()
		self.wplugins.values.map { |p| p.to_h }
	end
	
	attr_accessor :default
	
	#
	# Activa el plugin por defecto en la instancia
	#
	def wplugin_activate_default()
		@default = "default" if ! @default
		wplugin_activate(@default)
	end
	
	#
	# Activa un plugin en la instancia
	#
	# wplugin_name: el nombre del plugin a activar
	#
	def wplugin_activate(wplugin_name)
		wplugin = self.class.wplugins[wplugin_name]
		raise ArgumentError, "#{wplugin_name}: WPlugin not found" if ! wplugin
		
		wplugin.activate(self)
	end
	
end
