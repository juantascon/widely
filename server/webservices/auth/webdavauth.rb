module Auth

#
# El codigo de esta clase esta basado en codigo visto en:
# http://jps.kni.pk.edu.pl/2007/1/15/webrick-webdav-and-basic-authentication
# Por: Jan Szumiec
#
class WebDavHandlerAuth < WEBrick::HTTPServlet::WebDAVHandler
	
	#
	# Redefine el metodo de procesar cada peticion del manejador de
	# WebDAV por defecto
	#
	def service(req, resp)
		begin
			auth_header = req.header.fetch('authorization') do
				raise WEBrick::HTTPStatus::Unauthorized
			end
			
			auth_header = auth_header.first
			
			method, auth_data = auth_header.split(' ')
			
			# Decodifica la clave y el nombre de usuarios enviados
			username, password = Base64.decode64(auth_data).split(':')
			
			#autentica el usuario
			user = User::UserSet.instance.get(username, password)
			raise WEBrick::HTTPStatus::Unauthorized if ! user
			
			# Verifica que la ruta solicitada sea permitida por ese usuario
			real_path_rq = File.cleanpath("#{@root}#{req.path_info}")
			user_data_dir = File.dirname(user.data_dir)
			
			if real_path_rq.index(user_data_dir) != 0
				raise WEBrick::HTTPStatus::Unauthorized
			end
		rescue Exception => ex
			w_debug(ex.message)
			w_debug(ex.backtrace.join("\n\t"))
			
			resp.header['WWW-Authenticate'] = 'Basic realm="Widely"'
			raise WEBrick::HTTPStatus::Unauthorized
		end
		
		# Si llega a este punto es por que se ha autenticado con exito
		super(req, resp)
	end
	
end

#
# Modulo de manejo de WebDAV con autenticacion
#
module WebDavAuth
	
	include WebDav::Default
	
	#
	# Monta una ruta en el servidor
	#
	# mount_point: el punto de montaje
	# fs_path: la ruta del sistema de archivos
	#
	def mount(mount_point, fs_path)
		@server.mount(mount_point, WebDavHandlerAuth, fs_path)
	end
	
	#
	# Inicia el servidor en un nuevo hilo
	#
	def run()
		w_info "run(webdavauth)"
		return super
	end
	
	#
	# Detiene el servidor
	#
	def stop()
		w_info "stop(webdavauth)"
		return super
	end
	
end

# Registra plugin
WebDav::Dispatcher.register_wplugin(WPlugin.new("default_auth",
	"WebDav Plugin with Widely authentication support",
	WebDavAuth))

end
