class Plugin
	
	attr_reader :name, :klass
	
	def initialize(name, klass)
		@name = name
		@klass = klass
	end
	
	def make_instance(_self, *args, &block)
		@klass.new(_self, *args, &block)
	end
	
	def methods
		@klass.instance_methods - Object.instance_methods
	end
	
end


class Pluginable
	
	class_inheritable_accessor :plugins
	self.plugins = Hash.new
	
	def self.register_plugin(plugin)
		return false if self.plugins[plugin.name]
		self.plugins[plugin.name] = plugin
		return true
	end
	
	
	attr_reader :current
	
	def initialize
		self.extend SingleForwardable
	end
	
	def activate_plugin(plugin_name)
		plugin = self.class.plugins[plugin_name]
		raise Expcetion, "Errorsito" if ! plugin
		
		@current = plugin.make_instance(self)
		
		plugin.methods.each do |m|
			self.def_delegator("@current", m.to_sym, m.to_sym)
		end
	end
end
