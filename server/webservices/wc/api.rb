#
# API de WorkingCopy
#

module WC

class API
	
	include Singleton
	include WebService
	
	def create(args)
		args.check("session_id", "repos_id", "name", "manager")
		
		name = args["name"]
		manager = args["manager"]
		
		user = Auth::SessionSet.instance.get_ex(args["session_id"]).user
		raise ArgumentError.new("#{name}: workingcopy already exists") if user.wcs.get(name)
		
		repository = user.repos.get_ex(args["repos_id"])
		root_dir = user.data_dir
		
		return user.wcs.add(WorkingCopy.new(repository, root_dir, name, manager))
	end
	
	def checkout(args)
		args.check("session_id")
		session = Auth::SessionSet.instance.get_ex(args["session_id"])
		wc = session.wc
		version = Repos::Version.new(args["version"]) if args["version"]
		
		return wc.checkout(version)
	end

	def commit(args)
		args.check("session_id", "log")
		wc = Auth::SessionSet.instance.get_ex(args["session_id"]).wc
		
		return wc.commit(args["log"])
	end
	
	def versions(args)
		args.check("session_id")
		wc = Auth::SessionSet.instance.get_ex(args["session_id"]).wc
		
		return wc.versions()
	end
	
	def cat(args)
		args.check("session_id", "path")
		wc = Auth::SessionSet.instance.get_ex(args["session_id"]).wc
		version = Repos::Version.new(args["version"]) if args["version"]
		
		return wc.cat(args["path"], version)
	end
	
	def ls(args)
		args.check("session_id", "path")
		wc = Auth::SessionSet.instance.get_ex(args["session_id"]).wc
		version = Repos::Version.new(args["version"]) if args["version"]
		
		return wc.ls(args["path"], version)
	end
	
	def add(args)
		args.check("session_id", "path")
		wc = Auth::SessionSet.instance.get_ex(args["session_id"]).wc
		as_dir = ( args["as_dir"] == "true" )
		
		return wc.add(args["path"], as_dir)
	end
	
	def delete(args)
		args.check("session_id", "path")
		wc = Auth::SessionSet.instance.get_ex(args["session_id"]).wc
		
		return wc.delete(args["path"])
	end
	
	def move(args)
		args.check("session_id", "path_from", "path_to")
		wc = Auth::SessionSet.instance.get_ex(args["session_id"]).wc
		
		return wc.move(args["path_from"], args["path_to"])
	end
	
	def write(args)
		args.check("session_id", "path", "content")
		wc = Auth::SessionSet.instance.get_ex(args["session_id"]).wc
		
		return wc.write(args["path"], args["content"])
	end
end

HTTPAPI::WebServiceHandler.set_webservice("wc", WC::API.instance)

end
