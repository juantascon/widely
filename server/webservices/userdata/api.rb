#
# API de UserData
#

module UserData

class API
	
	include Singleton
	include WebService
	
	def set_value(args)
		args.check("session_id", "key", "value")
		
		key = args["key"]
		value = args["value"]
		
		user = Auth::SessionSet.instance.get_ex(args["session_id"]).user
		
		return true, user.userdataset.add(UserData.new(user, key, value))
	end
	
	def get_value(args)
		args.check("session_id", "key")
		
		key = args["key"]
		user = Auth::SessionSet.instance.get_ex(args["session_id"]).user
		user_data = user.userdataset.get_ex(key)
		
		return true, user_data.value
	end
	
end

HTTPAPI::WebServiceHandler.set_webservice("userdata", API.instance)

end
