module HTTPStatic
class Dispatcher < WPluginable
	
	attr_reader :port, :server
	
	def initialize(port, manager)
		@port = port
		
		activate_wplugin(manager)
		init_server()
	end
	
	def mount_backend(backend_name)
		case backend_name
			when "gui" then mount("/gui/", $WIDELY_HOME_GUI)
			when "qooxdoo" then mount("/qooxdoo-sdk/", "#{$WIDELY_HOME}/../qooxdoo-0.7-sdk/")
			when "doc" then mount("/doc/", $WIDELY_HOME_DOC)
			else raise Exception, "invalid backend: #{backend_name}"
		end
	end
	
end
end
