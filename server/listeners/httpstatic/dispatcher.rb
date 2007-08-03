module HTTPStatic
class Dispatcher < WPluginable
	
	attr_reader :port, :server
	
	def initialize(port, manager)
		@port = port
		
		wplugin_activate(manager)
		wplugin_init()
	end
	
	def mount_backend(backend_name)
		case backend_name
			when "gui" then mount("/gui/", $WIDELY_HOME_GUI)
			when "doc" then mount("/doc/", $WIDELY_HOME_DOC)
			else raise Exception, "invalid backend: #{backend_name}"
		end
	end
	
end
end
