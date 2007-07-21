#
# API de Repo
#

module Repo

class API
	
	include Singleton
	include WebService
	
	def manager_list(args)
		args.check("session_id")
		user = Auth::SessionSet.instance.get_ex(args["session_id"]).user
		return true, Repository.wplugin_list
	end
	
	def create(args)
		args.check("session_id", "name", "manager")
		
		name = args["name"]
		manager = args["manager"]
		
		user = Auth::SessionSet.instance.get_ex(args["session_id"]).user
		raise wex_arg("name", name, "repository already exists") if user.reposet.get(name)
		
		repo = Repository.new(user, name, manager)
		user.reposet.add(repo)
		
		return true, repo.collectable_key
	end
	
	def list(args)
		args.check("session_id")
		user = Auth::SessionSet.instance.get_ex(args["session_id"]).user
		
		ret = Array.new
		user.reposet.each { |key, object| ret.push object.to_h }
		
		return true, ret
	end
	
end

HTTPAPI::WebServiceHandler.set_webservice("repo", Repo::API.instance)

end
