#
# Plugin por defecto para el listener HTTPAPI
#

module HTTPAPI

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
	# Monta un metodo en un punto de montaje
	#
	def mount(mount_point, &block)
		main_proc = proc do |rq, resp|
			# Se hace el llamado al bloque
			real_resp = block.call(RQ.new(
				rq.request_method,
				rq.path,
				rq.body))
			
			#
			# Se almacena la respuesta obtenida dentro de la respuesta
			# a retornar
			#
			resp.body = real_resp.body
			resp.content_type = real_resp.content_type
			resp.status = real_resp.status
		end
		
		# Se monta el servicio
		@server.mount(mount_point, WEBrick::HTTPServlet::ProcHandler.new(main_proc))
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
Dispatcher.register_wplugin(WPlugin.new("default", "Default HTTPAPI Plugin", Default))

end
