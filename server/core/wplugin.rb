class WPlugin
	
	attr_reader :name, :definition, :instance
	
	def initialize(name, definition)
		@name = name
		@definition = definition
	end
	
	def activate(pluginable, *args, &block)
		case @definition.class.name
			when "Class"
				pluginable.extend SingleForwardable
				@instance = @definition.new(pluginable, *args, &block)
				
				methods = ( @definition.instance_methods - Object.instance_methods )
				methods.each do |m|
					pluginable.def_delegator("@instance", m.to_sym, m.to_sym)
				end
			when "Module"
				pluginable.extend @definition
			else
				raise StandardError, "#{@definition}: invalid definition"
		end
	end
	
end


class WPluginable
	
	class_inheritable_accessor :plugins
	self.plugins = Hash.new
	
	def self.register_plugin(plugin)
		return false if self.plugins[plugin.name]
		self.plugins[plugin.name] = plugin
		return true
	end
	
	def activate_plugin(plugin_name)
		plugin = self.class.plugins[plugin_name]
		raise ArgumentError, "#{plugin_name}: Plugin not found" if ! plugin
		
		plugin.activate(self)
	end
	
end
