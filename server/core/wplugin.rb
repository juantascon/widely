class WPlugin
	
	attr_reader :name, :definition, :instance
	
	def initialize(name, definition)
		@name = name
		@definition = definition
	end
	
	def activate(wpluginable, *args, &block)
		case @definition.class.name
			when "Class"
				wpluginable.extend SingleForwardable
				@instance = @definition.new(wpluginable, *args, &block)
				
				methods = ( @definition.instance_methods - Object.instance_methods )
				methods.each do |m|
					wpluginable.def_delegator("@instance", m.to_sym, m.to_sym)
				end
			when "Module"
				wpluginable.extend @definition
			else
				raise StandardError, "#{@definition}: invalid definition"
		end
	end
	
end


class WPluginable
	
	class_inheritable_accessor :wplugins
	self.wplugins = Hash.new
	
	def self.register_wplugin(wplugin)
		return false if self.wplugins[wplugin.name]
		self.wplugins[wplugin.name] = wplugin
		return true
	end
	
	attr_accessor :default
	
	def activate_default_wplugin()
		@default = "default" if ! @default
		activate_default_wplugin(@default)
	end
	
	def activate_wplugin(wplugin_name)
		wplugin = self.class.wplugins[wplugin_name]
		raise ArgumentError, "#{wplugin_name}: WPlugin not found" if ! wplugin
		
		wplugin.activate(self)
	end
	
end
