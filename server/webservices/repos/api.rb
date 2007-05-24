module Repos

class API
	
	include Singleton
	include WebService
	
	def create(args)
		args.check("session_id", "name")
		
		name = args["name"]
		
		session = args.collection_get(Auth::Sessions.instance, "session_id")
		raise ArgumentError.new("#{name}: repository already exists") if session.user.repos.get_o(name)
		
		manager_id = args["manager_id"].to_sym if args["manager_id"]
		
		obj = Repository.new(session.user, name, manager_id)
		
		return session.user.repos.save_o(obj)
	end
end

HTTP::APIHandler.set_webservice("repos", Repos::API.instance)

end
