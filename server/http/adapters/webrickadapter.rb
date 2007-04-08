module HTTP
module Adapters
class WEBrickAdapter < Base
	
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
		w_info("starting")
		@server.start
	end
	
	def stop()
		w_info("stoping")
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

