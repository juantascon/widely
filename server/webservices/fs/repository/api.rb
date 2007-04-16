module FS
class Repository

class API < Collection
	include Singleton
	include WebService
	
	def initialize
		super()
	end
	
	def create(args)
		args_check(args, "manager", "dir")
		obj = Repository.new(args["manager"].to_sym, args["dir"])
		
		return save_o(obj)
	end
	
end

Dispatcher.set_webservice("repos", API.instance)

end
end
