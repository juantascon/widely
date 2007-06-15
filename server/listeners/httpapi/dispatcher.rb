module HTTPAPI
class Dispatcher < WPluginable
	
	attr_reader :port
	
	def initialize(port, manager)
		@port = port
		
		wplugin_activate(manager)
		wplugin_init()
	end
	
	def mount_backend(backend_name)
		case backend_name
			when "api" then mount("/api/") { |rq| WebServiceHandler.process_rq(rq) }
			else raise Exception, "invalid backend: #{backend_name}"
		end
	end
	
end
end
