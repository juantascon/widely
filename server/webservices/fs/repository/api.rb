module FS
class Repository

class API
	extend WebService
	
	def API.create(args)
		args_check(args, "manager", "dir")
		obj = Repository.new(args["manager"].to_sym, args["dir"])
		
		return wso(obj)
	end
	
end

Dispatcher.set_webservice("repos", API)


end
end
