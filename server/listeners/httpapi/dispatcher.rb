module HTTPAPI
class Dispatcher < WPluginable
	
	attr_reader :port
	
	def initialize(port, manager)
		@port = port
		
		super()
		activate_wplugin(manager)
		init_server()
		mount("/api/") { |rq| WebServiceHandler.process_rq(rq) }
	end
	
end
end
