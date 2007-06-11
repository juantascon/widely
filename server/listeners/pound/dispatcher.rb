module Pound
class Dispatcher < WPluginable
	
	attr_reader :port, :server
	
	def initialize(port, manager)
		@port = port
		
		activate_wplugin(manager)
		init_server()
	end
	
end
end
