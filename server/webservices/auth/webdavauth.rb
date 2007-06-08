module Auth

#
# El codigo de esta clase esta basado en codigo visto en:
# http://jps.kni.pk.edu.pl/2007/1/15/webrick-webdav-and-basic-authentication
# Por: Jan Szumiec
#
class WebDavHandlerAuth < WEBrick::HTTPServlet::WebDAVHandler
	
	def service(req, resp)
		begin
			auth_header = req.header.fetch('authorization') do
				raise WEBrick::HTTPStatus::Unauthorized
			end.first
			
			method, auth_data = auth_header.split(' ')
			username, password = Base64.decode64(auth_data).split(':')
			
			#autentica el usuario
			user = Users.instance.authenticate(username, password)
			raise WEBrick::HTTPStatus::Unauthorized if ! user
			
			# Si la ruta solicitada es permitida por ese usuario
			if File.cleanpath("#{@root}#{req.path_info}").index(user.data_dir) != 0
				raise WEBrick::HTTPStatus::Unauthorized
			end
			
			# Si llega a este punto es por que se ha autenticado con exito
			super(req, resp)
		rescue Exception => ex
			w_debug(ex.message)
			w_debug(ex.backtrace.join("\n\t"))
			
			resp.header['WWW-Authenticate'] = 'Basic realm="Widely"'
			raise WEBrick::HTTPStatus::Unauthorized
		end
	end
	
end

module WebDavAuth
	
	include WebDav::Default
	
	def mount(mount_point, fs_path)
		@server.mount(mount_point, WebDavHandlerAuth, fs_path)
	end
	
	def run()
		w_info "run(webdavsauth)"
		return super
	end
	
	def stop()
		w_info "stop(webdavauth)"
		return super
	end
	
end

WebDav::Dispatcher.register_wplugin(WPlugin.new("default_auth", WebDavAuth))

end
