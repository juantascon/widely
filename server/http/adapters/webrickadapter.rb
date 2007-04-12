module HTTP
module Adapters
class WEBrickAdapter < Base
	
	def initialize(port, &block)
		main_proc = proc do |rq, resp|
			real_resp = block.call(RQ.new(
				rq.request_method,
				rq.path,
				rq.body))
			
			resp.body = real_resp.body
			resp.content_type = real_resp.content_type
			resp.status = real_resp.status
		end
		
		@server = WEBrick::HTTPServer.new :Port => port
		@server.mount("/", WEBrick::HTTPServlet::ProcHandler.new(main_proc))
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

