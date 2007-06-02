module HTTPAPI

module Default
	
	def init_server()
		logger = WEBrick::Log.new
		logger.level = WDEBUG_LEVEL
		@server = WEBrick::HTTPServer.new({:Port => @port, :Logger => logger})
	end
	
	def mount(mount_point, &block)
		main_proc = proc do |rq, resp|
			real_resp = block.call(RQ.new(
				rq.request_method,
				rq.path,
				rq.body))
			
			resp.body = real_resp.body
			resp.content_type = real_resp.content_type
			resp.status = real_resp.status
		end
		
		@server.mount(mount_point, WEBrick::HTTPServlet::ProcHandler.new(main_proc))
	end
	
	def run()
		w_info "run(webrick) => http://127.0.0.1:#{@port}"
		return Thread.new { @server.start }
	end
	
	def stop()
		w_info "stop(webrick) => http://127.0.0.1:#{@port}"
		return @server.shutdown
	end
	
end

Dispatcher.register_wplugin(WPlugin.new("default", Default))

end
