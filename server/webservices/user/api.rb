#
# API de Auth
#

module User

class API
	
	include Singleton
	include WebService
	
	def create(args)
		args.check("session_id", "user_id", "password")
		
		session = SessionSet.instance.get_ex(args["session_id"])
		raise ArgumentError, "session is not admin" if ! session.kind_of? AdminSession
		
		user_id = args["user_id"]
		password = args["password"]
		
		raise wex_arg("user_id", user_id, "user already exists") if WUser::Set.instance.get(user_id)
		
		return WUser::Set.instance.add(WUser.new(user_id, password))
	end
	
	def list(args)
		args.check("session_id")
		
		session = SessionSet.instance.get_ex(args["session_id"])
		raise ArgumentError, "session is not admin" if ! session.kind_of? AdminSession
		
		ret = Array.new
		WUser::Set.instance.each { |key, object| ret.push object.to_h }
		
		return ret
	end
	
end

HTTPAPI::WebServiceHandler.set_webservice("user", User::API.instance)

end
