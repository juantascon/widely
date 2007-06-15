module Pound
class Dispatcher < WPluginable
	
	attr_reader :port, :server
	
	def initialize(port, manager)
		@port = port
		
		wplugin_activate(manager)
		wplugin_init()
	end
	
end
end
