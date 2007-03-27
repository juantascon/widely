module Util
	class Service
		include Singleton
		
		def initialize
			@services = Hash.new
		end
		
		def register(name)
			@services[name.to_sym] = Array.new
		end
		
		def get_delegates(name)
			@services[name]
		end
		
		def add_delegate(service_name, delegate_class)
			@services[service_name].push(delegate_class)
		end
	end
end
