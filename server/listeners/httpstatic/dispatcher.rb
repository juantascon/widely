module HTTPStatic
class Dispatcher < Pluginable
	
	attr_reader :port
	
	def initialize(port)
		@port = port
		
		super()
		activate_plugin("default")
		
		mount("/gui/", $WIDELY_HOME_GUI)
		mount("/qooxdoo-sdk/", "#{$WIDELY_HOME}/../qooxdoo-0.7-beta1-sdk/")
		mount("/doc/", $WIDELY_HOME_DOC)
	end
	
end
end
