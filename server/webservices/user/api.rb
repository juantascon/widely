#
# API de User
#

module User

class API
	
	include Singleton
	include WebService
	
	def create(args)
		args.check("session_id", "user_id", "password")
		
		session = Auth::SessionSet.instance.get_ex(args["session_id"])
		return false, "session is not admin" if ! session.kind_of? Auth::AdminSession
		
		user_id = args["user_id"]
		password = args["password"]
		
		raise wex_arg("user_id", user_id, "user already exists") if WUser::Set.instance.get(user_id)
		
		user = WUser.new(user_id, password)
		WUser::Set.instance.add(user)
		
		return true, user.user_id
	end
	
	def list(args)
		args.check("session_id")
		
		session = Auth::SessionSet.instance.get_ex(args["session_id"])
		return false, "session is not admin" if ! session.kind_of? Auth::AdminSession
		
		ret = Array.new
		WUser::Set.instance.each { |key, object| ret.push object.to_h }
		
		return true, ret
	end
	
end

HTTPAPI::WebServiceHandler.set_webservice("user", User::API.instance)

end
