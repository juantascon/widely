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
		
		user = UserSet.instance.get_ex(args["user_id"], args["password"])
		return SessionSet.instance.add(Session.new(user))
	end
	
	def logout(args)
		args.check("session_id")
		
		return SessionSet.instance.delete_by_key(args["session_id"])
	end
	
	#TODO: esto deberia ir en otro lado (depronto en users)
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
