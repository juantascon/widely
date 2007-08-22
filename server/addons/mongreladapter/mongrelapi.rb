#
# Modulo de soporte de mongrel para HTTPAPI
#

module MongrelAdapter
module MongrelAPI
	
	#
	# Define el servidor
	#
	def wplugin_init()
		@server = Mongrel::HttpServer.new("0.0.0.0", @port.to_s)
	end
	
	#
	# Permite montar un bloque(closure) en el servidor
	#
	# mount_point: el punto de montaje en el servidor
	# block: el bloque a montar
	#
	def mount(mount_point, &block)
		handler = Mongrel::HttpHandler.new()
		
		#
		# Aqui se redefine el metodo process() encargado de procesar una peticion hacia el
		# servidor y retornar una respuesta
		# 
		class << handler
			#
			# Permite definir definir el atributo block de la instancia
			#
			def set_block(block)
				@block = block
			end
			
			#
			# Procesa una peticion del servidor pasandola a travez del bloque(closure)
			# retorna una respuesta de acuerdo al resultado
			#
			# rq: la peticion del servidor
			# resp: el objeto de la respuesta donde almacenar la informacion de respuesta
			#
			def process(rq, resp)
				
				# El bloque debe retornar un objeto HTTPAPI::Resp
				real_resp = @block.call(HTTPAPI::RQ.new(
					rq.params["REQUEST_METHOD"],
					rq.params["REQUEST_PATH"],
					rq.body.read))
				
				#
				# Se sacan los valores de la respuesta del bloque(closure) y se almacenan 
				# en la respuesta del servidor
				#
				resp.start(real_resp.status) do |head,body|
					head["Content-Type"] = real_resp.content_type
					body.write(real_resp.body)
				end
				
			end
			
		end
		
		# Se define el atributo block del manejador
		handler.set_block(block)
		
		# Se registra el manejador en el punto de montaje
		@server.register(mount_point, handler)
	end
	
	#
	# Inicia el servidor en un nuevo hilo
	#
	def run()
		w_info "run(mongrel) => http://127.0.0.1:#{@port}"
		return @server.run
	end
	
	#
	# detiene el servidor
	#
	def stop()
		w_info "STOP => httpapi:mongrel"
		return @server.stop
	end
	
end
end
