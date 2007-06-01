module HTTPStatic

class Default
	
	def initialize(_self)
		@_self = _self
		@port = @_self.port
		
		logger = WEBrick::Log.new
		logger.level = WDEBUG_LEVEL
		
		@server = WEBrick::HTTPServer.new({:Port => @port, :Logger => logger})
	end
	
	def mount(mount_point, fs_path, dir_listing=false)
		@server.mount(mount_point, WEBrick::HTTPServlet::FileHandler, fs_path, dir_listing)
	end
	
	def start_server()
		w_info "start: [#{self.class.name}] => http://127.0.0.1:#{@port}"
		return Thread.new { @server.start }
	end
	
	def stop_server()
		w_info "stop: [#{self.class.name}]"
		return @server.shutdown
	end
end

Dispatcher.register_plugin(Plugin.new("default", Default))

end
