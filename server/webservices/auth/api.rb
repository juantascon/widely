#
# API de Auth
#
module Auth

class API
	
	include Singleton
	include WebService
	
	attr_reader :users, :sessions
	
	def initialize
	end
	
	def login(args)
		args.check("user_id", "password")
		user = args.collection_get(Users.instance, "user_id", "password")
		
		return Sessions.instance.create(user)
	end
	
	def logout(args)
		args.check("session_id")
		
		return Sessions.delete_o(args["session_id"])
	end
	
	def set_wc(args)
		args.check("session_id", "wc_id")
		session = args.collection_get(Sessions.instance, "session_id")
		wc = args.collection_get(session.user.wcs, "wc_id")
		
		session.wc = wc
		return true
	end
	
end

HTTP::APIHandler.set_webservice("auth", Auth::API.instance)

end
