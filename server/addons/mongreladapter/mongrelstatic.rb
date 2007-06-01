module MongrelAdapter
module MongrelStatic
	
	def init_server()
		@server = Mongrel::HttpServer.new("0.0.0.0", @port.to_s)
	end
	
	def mount(mount_point, fs_path, dir_listing=false)
		@server.register(mount_point, Mongrel::DirHandler.new(fs_path))
	end
	
	def run()
		w_info "run => http://127.0.0.1:#{@port}"
		return @server.run
	end
	
	def stop()
		w_info "stop => http://127.0.0.1:#{@port}"
		return @server.stop
	end
	
end
end
