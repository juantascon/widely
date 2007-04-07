module HTTP
module Adater
class WEBrickAdapter
	
	attr :server
	
	def initialize(port, &block)
		
		main_proc = proc do |rq, resp|
			resp.body = block.call({
				"method" => request_method,
				"path" => rq.path,
				"body" => rq.body }).to_json
		end
		
		@server = WEBrick::HTTPServer.new :Port => port
		@server.mount("/", HTTPServlet::ProcHandler.new(main_proc))
	end
	
	def start()
		@server.start
	end
	
	def stop()
		@server.shutdown
	end
	
	def self.avaliable()
		begin
			require "webrick"
			return true if WEBrick
		rescue Exception
		end
		
		return false
	end
end
end
end

