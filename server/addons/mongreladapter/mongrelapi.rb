module MongrelAdapter
module MongrelAPI
	
	def init_server()
		@server = Mongrel::HttpServer.new("0.0.0.0", @port.to_s)
	end
	
	def mount(mount_point, &block)
		handler = Mongrel::HttpHandler.new()
		class << handler
			def set_block(block)
				@block = block
			end
			def process(rq, resp)
				real_resp = @block.call(HTTPAPI::RQ.new(
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
		@server.register(mount_point, handler)
	end
	
	def run()
		w_info "run(mongrel) => http://127.0.0.1:#{@port}"
		return @server.run
	end
	
	def stop()
		w_info "stop(mongrel) => http://127.0.0.1:#{@port}"
		return @server.stop
	end
	
end
end
