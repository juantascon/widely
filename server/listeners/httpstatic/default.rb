#
# Plugin por defecto para el listener HTTPStatic
#

module HTTPStatic

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
	# dir_listing: se deben listar el contenido de este directorio
	#
	def mount(mount_point, fs_path, dir_listing=false)
		@server.mount(mount_point, WEBrick::HTTPServlet::FileHandler, fs_path, dir_listing)
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
		w_info "stop(webrick) => http://127.0.0.1:#{@port}"
		return @server.shutdown
	end
end

# Registra el plugin
Dispatcher.register_wplugin(WPlugin.new("default", "Default HTTPStatic Plugin", Default))

end
