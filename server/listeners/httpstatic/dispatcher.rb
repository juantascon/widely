module HTTPStatic
class Dispatcher < WPluginable
	
	attr_reader :port, :server
	
	def initialize(port, manager)
		@port = port
		
		super()
		activate_wplugin(manager)
		
		init_server()
		mount("/gui/", $WIDELY_HOME_GUI)
		mount("/qooxdoo-sdk/", "#{$WIDELY_HOME}/../qooxdoo-0.7-sdk/")
		mount("/doc/", $WIDELY_HOME_DOC)
	end
	
end
end
