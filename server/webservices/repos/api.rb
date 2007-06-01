#
# API de Repos
#

module Repos

class API
	
	include Singleton
	include WebService
	
	def create(args)
		args.check("session_id", "name", "manager")
		
		name = args["name"]
		manager = args["manager"]
		
		user = Auth::SessionSet.instance.get_ex(args["session_id"]).user
		raise ArgumentError.new("#{name}: repository already exists") if user.repos.get(name)
		
		return user.repos.add(Repository.new(user, name, manager))
	end
end

HTTPAPI::WebServiceHandler.set_webservice("repos", Repos::API.instance)

end
