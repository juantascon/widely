#
# API de Repo
#

module Repo

class API
	
	include Singleton
	include WebService
	
	def create(args)
		args.check("session_id", "name", "manager")
		
		name = args["name"]
		manager = args["manager"]
		
		user = Auth::SessionSet.instance.get_ex(args["session_id"]).user
		raise ArgumentError.new("#{name}: repository already exists") if user.reposet.get(name)
		
		return user.reposet.add(Repository.new(user, name, manager))
	end
	
	def list(args)
		args.check("session_id")
		user = Auth::SessionSet.instance.get_ex(args["session_id"]).user
		
		ret = Array.new
		user.reposet.each { |key, object| ret.push object.to_h }
		
		return ret
	end
	
end

HTTPAPI::WebServiceHandler.set_webservice("repo", Repo::API.instance)

end
