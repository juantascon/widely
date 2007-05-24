module WebDav
module Adapters

class WEBrickAdapter < Base
	
	def initialize(port)
		logger = WEBrick::Log.new
		logger.level = WDEBUG_LEVEL
		
		@server = WEBrick::HTTPServer.new({:Port => port, :Logger => logger})
	end
	
	def set_webdav_handler(mount_point, fs_path)
		@server.mount(mount_point, WEBrick::HTTPServlet::WebDAVHandler, fs_path)
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
			WEBrick::HTTPServlet::WebDAVHandler
			return true
		rescue Exception
			return false
		end
	end
	
end

end
end
