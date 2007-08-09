#
# API de User
#

module User

class API
	
	include Singleton
	include WebService
	
	#
	# Crea un usuario nuevo
	#
	def create(args)
		args.check("session_id", "user_id", "password")
		
		session = Auth::SessionSet.instance.get_ex(args["session_id"])
		return false, "session is not admin" if ! session.kind_of? Auth::AdminSession
		
		user_id = args["user_id"]
		password = args["password"]
		
		raise wex_arg("user_id", user_id, "user already exists") if UserSet.instance.get(user_id)
		
		user = WUser.new(user_id, password)
		UserSet.instance.add(user)
		
		return true, user.user_id
	end
	
	#
	# Elimina un usuario
	#
	def destroy(args)
		args.check("session_id", "user_id")
		
		session = Auth::SessionSet.instance.get_ex(args["session_id"])
		return false, "session is not admin" if ! session.kind_of? Auth::AdminSession
		
		user_id = args["user_id"]
		user = UserSet.instance.get(user_id)
		
		raise wex_arg("user_id", user_id, "user does not exists") if ! user
		
		user.destroy
		
		return true
	end
	
	#
	# Retorna una lista de los usuario registrados
	#
	def list(args)
		args.check("session_id")
		
		session = Auth::SessionSet.instance.get_ex(args["session_id"])
		return false, "session is not admin" if ! session.kind_of? Auth::AdminSession
		
		ret = Array.new
		UserSet.instance.each { |key, object| ret.push object.to_h }
		
		return true, ret
	end
	
end

# Registra este API como un webservice
HTTPAPI::WebServiceHandler.set_webservice("user", User::API.instance)

end
