#
# API de Auth
#

module Auth

class API
	
	include Singleton
	include WebService
	
	def login(args)
		args.check("user_id", "password")
		
		user = WUser::Set.instance.get_ex(args["user_id"], args["password"])
		session = UserSession.new(user)
		
		if SessionSet.instance.add(session)
			return true, session.id
		else
			return false, "imposible to add session"
		end
	end
	
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
	
	def session_type(args)
		args.check("session_id")
		
		session = SessionSet.instance.get(args["session_id"])
		
		return true, "admin" if session.kind_of? AdminSession
		return true, "user" if session.kind_of? UserSession
		return true, "invalid"
	end
	
	def user_session(args)
		args.check("session_id", "user_id")
		
		session = SessionSet.instance.get_ex(args["session_id"])
		return false, "session is not admin" if ! session.kind_of? AdminSession
		
		user = WUser::Set.instance.get_ex(args["user_id"])
		
		new_session = UserSession.new(user)
		
		if SessionSet.instance.add(new_session)
			return true, new_session.id
		else
			return false, "imposible to add session"
		end
	end
	
	#TODO: esto deberia ser algo asi como set_session_data o estar en User
	def set_wc(args)
		args.check("session_id", "wc_id")
		session = SessionSet.instance.get_ex(args["session_id"])
		wc = session.user.wcset.get_ex(args["wc_id"])
		
		session.wc = wc
		return true
	end
	
	def logout(args)
		args.check("session_id")
		SessionSet.instance.delete_by_key(args["session_id"])
		
		return true
	end
end

HTTPAPI::WebServiceHandler.set_webservice("auth", Auth::API.instance)

end
