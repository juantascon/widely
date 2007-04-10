module HTTP
module Dispatch
	
	@@webservices = Hash.new
	
	def set_webservice(webservice)
		@@webservices[webservice.name] = webservice
	end
	
	
	def load_server(port)
		server = nil
		
		[Adapters::MongrelAdapter, Adapters::WEBrickAdapter].each do |adapter|
			next if ! adapter.avaliable
			if ! server
				server = adapter.new(port) do |h|
					path = File.cleanpath(h["path"])
					return {"error" => "#{h["path"]: invalid request"} if ! path.absolute
					path[0] = ""
					
					rqtype = path.split("/")[0]
					case rqtype
						when "api"
							return { "error" => "try with POST instead of #{h["method"]}" } if h["method"] != "POST"
							
							webservice_name = path.split("/")[1]
							webservice = @@webservices[webservice_name]
							return { "error" => "#{webservice_name}: webservice not found" } if ! webservice
							
							method_name = path.split("/")[2]
							begin
								method = webservice.method(method_name.to_sym)
							rescue NameError
								return { "error" => "#{method_name}: method not found" }
							end
							
							#
							# Aqui deberia estar el llamado a method con un parsing de h["body"]
							#
							
						when "gui"
							return { "error" => "gui not avaliable yet" }
						else
							return { "error" => "h["path"]: not found" }
					end
				end
			end
		end
	end
	
	def start_server()
		["INT", "TERM" ].each { |signal| trap(signal) { server.stop } }
		print "=> Escuchando en http://127.0.0.1:#{port}"
		print "=> Ctrl-C para terminar"
		server.start
	end
	
	module_function :start_server, :load_server
end
end

