#
# API de WorkingCopy
#

module WC

class API
	
	include Singleton
	include WebService
	
	def create(args)
		args.check("session_id", "repos_id", "name")
		
		name = args["name"]
		
		session = args.collection_get(Auth::Sessions.instance, "session_id")
		raise ArgumentError.new("#{name}: workingcopy already exists") if session.user.wcs.get_o(name)
		
		repository = args.collection_get(session.user.repos, "repos_id")
		
		manager_id = args["manager_id"].to_sym if args["manager_id"]
		
		obj = WorkingCopy.new(session.user, repository, name, manager_id)
		
		return session.user.wcs.save_o(obj)
	end
	
	def checkout(args)
		args.check("session_id")
		session = args.collection_get(Auth::Sessions.instance, "session_id")
		version = Repos::Version.new(args["version"]) if args["version"]
		
		return session.wc.checkout(version)
	end

	def commit(args)
		args.check("session_id", "log")
		session = args.collection_get(Auth::Sessions.instance, "session_id")
		
		return session.wc.commit(args["log"])
	end
	
	def versions(args)
		args.check("session_id")
		session = args.collection_get(Auth::Sessions.instance, "session_id")
		
		return session.wc.versions()
	end
	
	def cat(args)
		args.check("session_id", "path")
		session = args.collection_get(Auth::Sessions.instance, "session_id")
		version = Repos::Version.new(args["version"]) if args["version"]
		
		return session.wc.cat(args["path"], version)
	end
	
	def ls(args)
		args.check("session_id", "path")
		session = args.collection_get(Auth::Sessions.instance, "session_id")
		version = Repos::Version.new(args["version"]) if args["version"]
		
		return session.wc.ls(args["path"], version)
	end
	
	def add(args)
		args.check("session_id", "path")
		session = args.collection_get(Auth::Sessions.instance, "session_id")
		as_dir = ( args["as_dir"] == "true" )
		
		return session.wc.add(args["path"], as_dir)
	end
	
	def delete(args)
		args.check("session_id", "path")
		session = args.collection_get(Auth::Sessions.instance, "session_id")
		
		return session.wc.delete(args["path"])
	end
	
	def move(args)
		args.check("session_id", "path_from", "path_to")
		session = args.collection_get(Auth::Sessions.instance, "session_id")
		
		return session.wc.move(args["path_from"], args["path_to"])
	end
	
	def write(args)
		args.check("session_id", "path", "content")
		session = args.collection_get(Auth::Sessions.instance, "session_id")
		
		return session.wc.write(args["path"], args["content"])
	end
end

HTTP::APIHandler.set_webservice("wc", WC::API.instance)

end
