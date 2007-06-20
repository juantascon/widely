#
# API de Auth
#

module Auth

class API
	
	include Singleton
	include WebService
	
	attr_reader :users, :sessions
	
	def login(args)
		args.check("user_id", "password")
		
		user = WUser::Set.instance.get_ex(args["user_id"], args["password"])
		return SessionSet.instance.add(UserSession.new(user))
	end
	
	def login_admin(args)
		args.check("password")
		
		password = args["password"]
		
		return SessionSet.instance.add(AdminSession.new(password))
	end
	
	def logout(args)
		args.check("session_id")
		
		return SessionSet.instance.delete_by_key(args["session_id"])
	end
	
	def user_session(args)
		args.check("session_id", "user_id")
		
		session = SessionSet.instance.get_ex(args["session_id"])
		raise ArgumentError, "session is not admin" if ! session.kind_of? AdminSession
		user = WUser::Set.instance.get_ex(args["user_id"])
		
		return SessionSet.instance.add(UserSession.new(user))
	end
	
	#TODO: esto deberia ser algo asi como set_session_data
	def set_wc(args)
		args.check("session_id", "wc_id")
		session = SessionSet.instance.get_ex(args["session_id"])
		wc = session.user.wcset.get_ex(args["wc_id"])
		
		session.wc = wc
		return true
	end
end

HTTPAPI::WebServiceHandler.set_webservice("auth", Auth::API.instance)

end
