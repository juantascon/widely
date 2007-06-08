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
		
		return user.dataset.add_at(key, value)
	end
	
	def get_value(args)
		args.check("session_id", "key")
		
		key = args["key"]
		
		user = Auth::SessionSet.instance.get_ex(args["session_id"]).user
		
		return user.dataset.get_ex(key)
	end
	
end

HTTPAPI::WebServiceHandler.set_webservice("userdata", UserData::API.instance)

end
