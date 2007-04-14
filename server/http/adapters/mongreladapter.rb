module HTTP
module Adapters
class MongrelAdapter < Base
	
	def initialize(port, &block)
		handler = Mongrel::HttpHandler.new()
		class << handler
			def set_block(block)
				@block = block
			end
			def process(rq, resp)
				real_resp = @block.call(RQ.new(
					rq.params["REQUEST_METHOD"],
					rq.params["REQUEST_PATH"],
					rq.body.read))
					
				resp.start(real_resp.status) do |head,body|
					head["Content-Type"] = real_resp.content_type
					body.write(real_resp.body)
				end
			end
		end
		handler.set_block(block)
		
		@server = Mongrel::HttpServer.new("0.0.0.0", port.to_s)
		@server.register("/", handler)
	end
	
	def start()
		w_info("starting")
		@server.run.join
	end
	
	def stop()
		w_info("stoping")
		@server.stop
	end
	
	def self.avaliable()
		begin
			require "rubygems"
			gem "mongrel"
			require "mongrel"
			return true if Mongrel
		rescue Exception
		end
		
		return false
	end
end
end
end

