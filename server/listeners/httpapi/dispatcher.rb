module HTTPAPI
class Dispatcher < WPluginable
	
	attr_reader :port
	
	def initialize(port)
		@port = port
		
		super()
		activate_wplugin("default")
		init_server()
		mount("/api/") { |rq| WebServiceHandler.process_rq(rq) }
	end
	
end
end
