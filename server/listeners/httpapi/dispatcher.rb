module HTTPAPI
class Dispatcher < Pluginable
	
	attr_reader :port
	
	def initialize(port)
		@port = port
		
		super()
		activate_plugin("default")
		init_server()
		mount("/api/") { |rq| WebServiceHandler.process_rq(rq) }
	end
	
end
end
