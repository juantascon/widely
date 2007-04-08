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
				resp.start() do |head,body|
					body.write(@block.call({
						"method" => rq.params["REQUEST_METHOD"],
						"path" => rq.params["REQUEST_PATH"],
						"body" => rq.body.read }).to_json)
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

