module HTTPclass Dispatcher
	#
	# TODO: agregar soporte para Adapters en modulos
	#
	
	attr_reader :webservices, :server
	@webservices = Hash.new
	
	def set_webservice(webservice)
		@webservices[webservice.name] = webservice
	end
	
	
	def initialize(port)
		[Adapters::MongrelAdapter, Adapters::WEBrickAdapter].each do |adapter|
			next if ! adapter.avaliable
			@server = adapter.new(port) do |rq|
				path = File.cleanpath(rq.path)
				return Resp.new_json_error("#{rq.path}: invalid request") if ! path.absolute
				
				path[0] = ""
				rqtype = path.split("/")[0]
				case rqtype
					when "api"
						return Resp.new_json_error("try with POST instead of #{rq.method}") if rq.method != "POST"
						
						webservice_name = path.split("/")[1]
						webservice = @@webservices[webservice_name]
						return Resp.new_json_error("#{webservice_name}: webservice not found") if ! webservice
						
						method_name = path.split("/")[2]
						begin
							method = webservice.method(method_name.to_sym)
						rescue NameError
							return Resp.new_json_error("#{method_name}: method not found")
						end
						
						begin
							method.call
						#
						# Aqui deberia estar el llamado a method con un parsing de rq.body
						#
						
					when "gui"
						return
						
						#
						# Aqui deberia haber un manejo simple para los archivos gui(estaticos)
						#
						
					else
						return Resp.new_json_error("Path not found")
				end
			end
		end
	end
end
	
	def start_server()
		["INT", "TERM" ].each { |signal| trap(signal) { @server.stop } }
		print "=> Escuchando en http://127.0.0.1:#{port}"
		print "=> Ctrl-C para terminar"
		@server.start
	end
	
	module_function :start_server, :load_server
end
end

