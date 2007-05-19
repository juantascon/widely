module FS
class Repository

class API
	
	include Singleton
	include WebService
	
	def initialize
		super()
	end
	
	def create(args)
		args.check("session_id", "manager_id", "name")
		
		session = args.collection_get(Auth::Sessions.instance, "session_id")
		
		if session.user.repos.get_o(args["name"])
			raise ArgumentError.new("#{args["name"]}: repository already exists")
		end
		
		obj = Repository.new(session.user, args["manager_id"].to_sym, args["name"])
		return session.user.repos.save_o(obj)
	end
end

HTTP::Dispatcher.set_webservice("repos", FS::Repository::API.instance)

end
end
