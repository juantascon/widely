module WebDav
class Dispatcher < WPluginable
	
	attr_reader :port, :server
	
	def initialize(port, manager)
		@port = port
		
		wplugin_activate(manager)
		wplugin_init()
	end
	
	def mount_backend(backend_name)
		case backend_name
			when "data" then mount("/data/", "#{$WIDELY_DATA_DIR}/users")
			else raise Exception, "invalid backend: #{backend_name}"
		end
	end
	
end
end
