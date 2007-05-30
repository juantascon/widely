#
# API de Repos
#

module Repos

class API
	
	include Singleton
	include WebService
	
	def create(args)
		args.check("session_id", "name")
		
		name = args["name"]
		
		user = Auth::SessionSet.instance.get(args["session_id"]).user
		raise ArgumentError.new("#{name}: repository already exists") if user.repos.get(name)
		
		manager_id = args["manager_id"].to_sym if args["manager_id"]
		
		return user.repos.add(Repository.new(user, name, manager_id))
	end
end

HTTP::APIHandler.set_webservice("repos", Repos::API.instance)

end
