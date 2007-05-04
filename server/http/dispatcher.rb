module HTTP
class Dispatcher
	#
	# TODO: agregar soporte para Adapters como addons
	#
	
	attr_reader :server, :port
	
	#
	# La coleccion de WebServices para saber hacia donde redirigir
	# las peticiones
	#
	@@webservices = Hash.new
	
	def self.set_webservice(id, webservice)
		w_info("WebService[#{id}]: #{webservice}")
		@@webservices[id] = webservice
	end
	
	#
	# Procesa las peticiones del API dependiendo del webservice
	# y del metodo
	#
	def api_handler(rq)
		# La ruta real es sin "/api/"
		path = rq.path.gsub(/^\/api\//, "")
		
		# En el API solo se aceptan peticiones POST
		return Resp.new_method_not_allowed() if rq.method != "POST"
		
		#
		# El primer directorio indica que webservice utilizar
		#
		# /api/wc: api de copia de trabajo
		# /api/auth: api de autenticacion
		# ...
		#
		webservice_name = path.split("/")[0]
		w_debug("path: #{path}");
		webservice = @@webservices[webservice_name]
		return Resp.new_not_found() if ! webservice
		
		#
		# El segundo directorio indica que metodo ejecutar en
		# el webservice
		#
		# /api/wc/status: metodo status de la copia de trabajo
		# /api/auth/login: metodo login del webservice auth
		#
		method_name = path.split("/")[1]
		
		#
		# El ultimo paso es ejecutar el metodo del webservice con los parametros
		# sacados de hacer parsing del request (rq.body)
		#
		begin
			ret = webservice.call(method_name, Parser.url_encoded_args_to_hash(rq.body))
		rescue Exception => ex
			w_debug("#{ex.to_str}\n#{ex.backtrace}")
			return Resp.new_error_json("#{method_name} [Exception]: #{ex.message}")
		end
		
		return Resp.new_json(ret)
	end
	
	#
	# Busca entre los adaptadores disponibles para iniciarlo
	# y ponerlo a escuchar en @port
	#
	def initialize(port)
		@port = port
		
		[Adapters::MongrelAdapter, Adapters::WEBrickAdapter].each do |adapter|
			next if ! adapter.avaliable
			break if @server
			
			@server = adapter.new(@port)

			@server.set_file_handler("/gui/", "#{$WIDELY_HOME}/gui/")
			@server.set_file_handler("/qooxdoo-sdk/", "#{$WIDELY_HOME}/../qooxdoo-0.7-alpha2-sdk/")
			@server.set_file_handler("/doc/", "#{$WIDELY_HOME}/doc")
			@server.set_proc_handler("/api/") { |rq| api_handler(rq) }
		end
	end
	
	#
	# Inicia el servidor Web
	#
	def start_server()
		# Atrapa las señales para que sean manejadas correctamente
		["INT", "TERM" ].each { |signal| trap(signal) { @server.stop } }
		
		w_info "=> Escuchando en http://127.0.0.1:#{port}"
		w_info "=> Ctrl-C para terminar"
		
		@server.start
	end
	
end
end
