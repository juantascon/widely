#
# Plugin por defecto para el listener WebDAV
#

module WebDav

module Default
	
	#
	# Inicia el servidor
	#
	def wplugin_init()
		logger = WEBrick::Log.new
		logger.level = WDEBUG_LEVEL
		@server = WEBrick::HTTPServer.new({:Port => @port, :Logger => logger})
	end
	
	#
	# Monta una ruta del sistema de archivos real
	#
	# mount_point: el punto de montaje
	# fs_path: la ruta del sistema de archivos
	#
	def mount(mount_point, fs_path)
		@server.mount(mount_point, WEBrick::HTTPServlet::WebDAVHandler, fs_path)
	end
	
	#
	# Inicia el listener en un nuevo hilo
	#
	def run()
		w_info "run(webrick) => http://127.0.0.1:#{@port}"
		return Thread.new { @server.start }
	end
	
	#
	# Detiene el listener
	#
	def stop()
		w_info "STOP => webdav:webrick"
		return @server.shutdown
	end
end

# Registra el plugin
Dispatcher.register_wplugin(WPlugin.new("default",  "Default WebDav Plugin",Default))

end
