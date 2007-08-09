#
# API de Auth
#

module Auth

class API
	
	include Singleton
	include WebService
	
	#
	# Realiza una entrada al sistema retornando una llave de session
	#
	def login(args)
		args.check("user_id", "password")
		
		user = User::UserSet.instance.get_ex(args["user_id"], args["password"])
		session = UserSession.new(user)
		
		if SessionSet.instance.add(session)
			return true, session.id
		else
			return false, "imposible to add session"
		end
	end
	
	#
	# Realiza un login en el sistema como administrador
	#
	def login_admin(args)
		args.check("password")
		
		password = args["password"]
		
		session = AdminSession.new(password)
		
		if SessionSet.instance.add(session)
			return true, session.id
		else
			return false, "imposible to add session"
		end
	end
	
	#
	# Cambia la clave del usuario
	#
	def change_password(args)
		args.check("session_id", "password_old", "password_new")
		
		password_old = args["password_old"]
		password_new = args["password_new"]
		
		session = SessionSet.instance.get_ex(args["session_id"])
		
		return session.change_password(password_old, password_new)
	end
	
	#
	# Retorna el tipo de session (admin|user|invalid)
	#
	def session_type(args)
		args.check("session_id")
		
		session = SessionSet.instance.get(args["session_id"])
		
		return true, "admin" if session.kind_of? AdminSession
		return true, "user" if session.kind_of? UserSession
		return true, "invalid"
	end
	
	#
	# Registra una session de usuario a partir de una session admin
	#
	def user_session(args)
		args.check("session_id", "user_id")
		
		session = SessionSet.instance.get_ex(args["session_id"])
		return false, "session is not admin" if ! session.kind_of? AdminSession
		
		user = User::UserSet.instance.get_ex(args["user_id"])
		
		new_session = UserSession.new(user)
		
		if SessionSet.instance.add(new_session)
			return true, new_session.id
		else
			return false, "imposible to add session"
		end
	end
	
	#TODO: esto deberia ser algo asi como set_session_data o estar en User
	
	#
	# Define la copia de trabajo a utilizar en la session
	#
	def set_wc(args)
		args.check("session_id", "wc_id")
		session = SessionSet.instance.get_ex(args["session_id"])
		wc = session.user.wcset.get_ex(args["wc_id"])
		
		session.wc = wc
		return true
	end
	
	#
	# Elimina una session
	#
	def logout(args)
		args.check("session_id")
		SessionSet.instance.delete_by_key(args["session_id"])
		
		return true
	end
end

# Registra este API como un webservice
HTTPAPI::WebServiceHandler.set_webservice("auth", Auth::API.instance)

end
