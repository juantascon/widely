module HTTP
module Adater
class MongrelAdapter
	attr :server
	
	class ProcHandler < Mongrel::HttpHandler
		attr :block
		
		def initialize(&block)
			@block = block
		end
		
		def process(rq, resp)
			response.start() do |head,body|
				body.write(@block.call({
					"method" => rq.params["REQUEST_METHOD"],
					"path" => rq.params["REQUEST_PATH"],
					"body" => rq.body.read }).to_json)
			end
		end
	end
	
	def initialize(port, &block)
		@server = Mongrel::HttpServer.new("0.0.0.0", port.to_s)
		@server.register("/", ProcHandler.new(&block))
	end
	
	def start()
		@server.run.join
	end
	
	def stop()
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

