module HTTPclass Dispatcher
	#
	# TODO: agregar soporte para Adapters en modulos
	#
	
	#
	# La coleccion de WebServices para saber hacia donde redirigir
	# las peticiones
	#
	@@webservices = Hash.new
	
	def self.set_webservice(webservice)
		@@webservices[webservice.name] = webservice
	end
	
	attr_reader :server
	def initialize(port)
		
		[Adapters::MongrelAdapter, Adapters::WEBrickAdapter].each do |adapter|
			
			next if ! adapter.avaliable
			break if @server
			
			@server = adapter.new(port) do |rq|
				
				# Limpia la ruta y revisa si es una ruta Absoluta
				path = File.cleanpath(rq.path)
				return Resp.new_json_error("#{rq.path}: invalid request") if ! path.absolute
				
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
						begin
							method = webservice.method(method_name.to_sym)
						rescue NameError
							return Resp.new_json_error("#{method_name}: method not found")
						end
						
						#
						# Por ultimo se ejecuta el metodo con los parametros dados
						#
						#begin
						#	method.call
						
						#
						# Aqui deberia estar el llamado a method con un parsing de rq.body
						#
						
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
		end
	end
	
	#
	# Inicia el servidor Web
	#
	def start_server()
		# Atrapa las señales para que sean manejadas correctamente
		["INT", "TERM" ].each { |signal| trap(signal) { @server.stop } }
		
		print "=> Escuchando en http://127.0.0.1:#{port}"
		print "=> Ctrl-C para terminar"
		
		@server.start
	end
	
end
end

