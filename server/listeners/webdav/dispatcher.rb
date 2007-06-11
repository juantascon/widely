module WebDav
class Dispatcher < WPluginable
	
	attr_reader :port, :server
	
	def initialize(port, manager)
		@port = port
		
		activate_wplugin(manager)
		init_server()
	end
	
	def mount_backend(backend_name)
		case backend_name
			when "data" then mount("/data/", $CONFIG.get("CORE_DATA_DIR").get_value)
			else raise Exception, "invalid backend: #{backend_name}"
		end
	end
	
end
end
