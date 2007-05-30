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
		
		user = UserSet.instance.get(args["user_id"], args["password"])
		return SessionSet.instance.add(Session.new(user))
	end
	
	def logout(args)
		args.check("session_id")
		
		return SessionSet.instance.delete(args["session_id"])
	end
	
	def set_wc(args)
		args.check("session_id", "wc_id")
		session = SessionSet.instance.get(args["session_id"])
		wc = session.user.wcs.get(args["wc_id"])
		
		session.wc = wc
		return true
	end
	
end

HTTP::APIHandler.set_webservice("auth", Auth::API.instance)

end
