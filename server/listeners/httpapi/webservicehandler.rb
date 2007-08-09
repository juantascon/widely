#
# Maneja el registro e invocacion de los webservices
#
module HTTPAPI
class WebServiceHandler
	
	#
	# La coleccion de WebServices para saber hacia donde redirigir
	# las peticiones
	#
	@@webservices = Hash.new
	
	#
	# Registra un nuevo webservice
	#
	# id: el identificador del webservice
	# webservice: la clase manejadora del webservice
	#
	def self.set_webservice(id, webservice)
		w_info("WebService[#{id}]: #{webservice}")
		@@webservices[id] = webservice
	end
	
	#
	# Procesa las peticiones del API dependiendo del webservice
	# y del metodo
	#
	def self.process_rq(rq)
		# La ruta real es sin "/api/"
		path = rq.path.gsub(/^\/api\//, "")
		
		w_info("API: #{path}")
		
		# En el API solo se aceptan peticiones POST
		return Resp.new_method_not_allowed(rq.method) if rq.method != "POST"
		
		#
		# El primer directorio indica que webservice utilizar
		#
		# /api/wc: api de copia de trabajo
		# /api/auth: api de autenticacion
		# ...
		#
		webservice_name = path.split("/")[0]
		webservice = @@webservices[webservice_name]
		
		return Resp.new_not_found(path) if ! webservice
		
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
			# Obtiene los argumentos pasados en la peticion
			ws_args = URLParser.url_encoded_args_to_hash(rq.body)
			w_debug("API ARGS: #{ws_args}")
			
			# Hace el llamado del webservice
			status, ret = webservice.call(method_name, ws_args)
		rescue Exception => ex
			w_debug("Exception: #{ex.message}")
			w_debug(ex.backtrace.join("\n\t"))
			
			# En caso de exception retorna un mensaje de error
			return Resp.new_json_ex("#{webservice_name}/#{method_name}", ex.message)
		end
		
		# Termino correctamente la invocacion del webservice?
		if status
			return Resp.new_json_ok("#{webservice_name}/#{method_name}", ret)
		else
			return Resp.new_json_fail("#{webservice_name}/#{method_name}", ret)
		end
		
	end
	
end

end
