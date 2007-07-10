module HTTPStatic

module Default
	
	def wplugin_init()
		logger = WEBrick::Log.new
		logger.level = WDEBUG_LEVEL
		@server = WEBrick::HTTPServer.new({:Port => @port, :Logger => logger})
	end
	
	def mount(mount_point, fs_path, dir_listing=false)
		@server.mount(mount_point, WEBrick::HTTPServlet::FileHandler, fs_path, dir_listing)
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

Dispatcher.register_wplugin(WPlugin.new("default", "Default HTTPStatic Plugin", Default))

end
