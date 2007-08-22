#
# Modulo de manejo de mongrel para listener HTTPStatic
#

module MongrelAdapter
module MongrelStatic
	
	#
	# Define el servidor
	#
	def wplugin_init()
		@server = Mongrel::HttpServer.new("0.0.0.0", @port.to_s)
	end
	
	#
	# Monta una ruta del sistema de archivos real en el servidor
	#
	# mount_point: el punto de montaje
	# fs_path: la ruta del sistema de archivos real
	# dir_listing: si es true permite listar los directorios en el servidor cuando
	# se seleccione el punto de montaje
	#
	def mount(mount_point, fs_path, dir_listing=false)
		@server.register(mount_point, Mongrel::DirHandler.new(fs_path))
	end
	
	#
	# Inicia el servidor en un nuevo hilo
	#
	def run()
		w_info "run(mongrel) => http://127.0.0.1:#{@port}"
		return @server.run
	end
	
	#
	# Detiene el servidor
	#
	def stop()
		w_info "STOP => httpstatic:mongrel"
		return @server.stop
	end
	
end
end
