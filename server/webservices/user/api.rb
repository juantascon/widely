#
# API de WUser
#

module WUser

class API
	
	include Singleton
	include WebService
	
	def create(args)
		args.check("session_id", "user_id", "password")
		
		session = Auth::SessionSet.instance.get_ex(args["session_id"])
		return false, "session is not admin" if ! session.kind_of? Auth::AdminSession
		
		user_id = args["user_id"]
		password = args["password"]
		
		raise wex_arg("user_id", user_id, "user already exists") if Set.instance.get(user_id)
		
		user = User.new(user_id, password)
		Set.instance.add(user)
		
		return true, user.user_id
	end
	
	def list(args)
		args.check("session_id")
		
		session = Auth::SessionSet.instance.get_ex(args["session_id"])
		return false, "session is not admin" if ! session.kind_of? Auth::AdminSession
		
		ret = Array.new
		Set.instance.each { |key, object| ret.push object.to_h }
		
		return true, ret
	end
	
end

HTTPAPI::WebServiceHandler.set_webservice("user", API.instance)

end
