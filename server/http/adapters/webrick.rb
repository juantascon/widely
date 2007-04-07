module HTTP
module Adater
class WEBrickAdapter
	require 'webrick'
	
	attr :server
	
	def initialize(port, &block)
		
		main_proc = proc do |rq, res|
			
		end
		
		@server = WEBrick::HTTPServer.new :Port => port
		@server.mount("/", HTTPServlet::ProcHandler.new(main_proc))
	end
	
	def run()
		@server.start
	end
end
end
end

