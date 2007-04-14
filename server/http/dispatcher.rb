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
	
	def self.set_webservice(webservice)
		w_info("WebService[#{webservice.webservice_name}]: #{webservice}")
		@@webservices[webservice.webservice_name] = webservice
	end
	
	def process_request(rq)
		# Limpia la ruta y revisa si es una ruta Absoluta
		w_debug("#{rq}")
		path = File.cleanpath(rq.path)
		return Resp.new_json_error("#{rq.path}: invalid request") if ! File.absolute?(path)
		
		#
		# El primer directorio indica que tipo de peticion es
		# /api: peticion de webservice
		# /gui: peticion de archivos estaticos de gui
		# /doc: la documentacion
		#
		path[0] = ""
		rqtype = path.split("/")[0]
		case rqtype
			
			when "api"
				# Para el API solo se aceptan peticiones POST
				return Resp.new_json_error("try with POST instead of #{rq.method}") if rq.method != "POST"
				
				#
				# El segundo directorio indica que webservice utilizar
				#
				# /api/wc: api de copia de trabajo
				# /api/repos: api de repositorio
				# /api/auth: api de autenticacion
				#
				webservice_name = path.split("/")[1]
				webservice = @@webservices[webservice_name]
				return Resp.new_json_error("#{webservice_name}: webservice not found") if ! webservice
				
				#
				# El tercer directorio indica que metodo ejecutar en
				# el webservice
				#
				# /api/wc/status: metodo status de la copia de trabajo
				# /api/auth/login: metodo login del webservice auth
				#
				method_name = path.split("/")[2]
				
				#
				# El ultimo paso es ejecutar el metodo del webservice con los parametros
				# sacados de hacer parsing del request (rq.body)
				#
				begin
					webservice.call(method_name, Parser.url_encoded_args_to_hash(rq.body))
				rescue NameError, NoMethodError => ex
					w_debug("#{ex.to_str}\n#{ex.backtrace}")
					return Resp.new_json_error("#{ex.message}")
				rescue Exception => ex
					w_debug("#{ex.to_str}\n#{ex.backtrace}")
					return Resp.new_json_error("#{method_name} [Exception]: #{ex.message}")
				end
				
			when "gui"
				return
				
				#
				# Aqui deberia haber un manejo simple para los archivos gui(estaticos)
				#
			when "doc"
				return 
				#
				# Aqui deberia haber un manejo simple para los archivos doc(estaticos?)
				#
			else
				return Resp.new_json_error("Path not found")
		end
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
			
			@server = adapter.new(@port) do |rq|
				process_request(rq)
			end
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
