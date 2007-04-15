#
# API de WorkingCopy
#

module FS
class WorkingCopy

class API
	
	extend WebService
	
	def API.create(args)
		args_check(args, "wc_dir", "repository_wso_id")
		
		repository = find_wso(args["repository_wso_id"].to_i)
		raise ArgumentError.new("repository[#{args["repository_wso_id"]}]: invalid") if ! repository
		
		obj = WorkingCopy.new(args["wc_dir"], repository)
		
		return wso(obj)
	end
	
	def API.checkout(args)
		args_check(args, "wso_id")
		obj = find_wso(args["wso_id"])
		
		return obj.checkout(args["version"])
	end

	def API.commit(args)
		args_check(args, "wso_id", "log")
		obj = find_wso(args["wso_id"])
		
		return obj.commit(args["log"])
	end
	
	def API.versions(args)
		args_check(args, "wso_id")
		obj = find_wso(args["wso_id"])
		
		return obj.versions()
	end
	
	def API.cat(args)
		args_check(args, "wso_id", "path")
		obj = find_wso(args["wso_id"])
		
		return obj.cat(args["path"], args["version"])
	end
	
	def API.ls(args)
		args_check(args, "wso_id", "path")
		obj = find_wso(args["wso_id"])
		
		return obj.ls(args["path"], args["version"])
	end
	
	def API.add(args)
		args_check(args, "wso_id", "path")
		obj = find_wso(args["wso_id"])
		
		as_dir = args["as_dir"] == "true"
		
		return obj.add(args["path"], as_dir)
	end
	
	def API.delete(args)
		args_check(args, "wso_id", "path")
		obj = find_wso(args["wso_id"])
		
		return obj.delete(args["path"])
	end
	
	def API.move(path_from, path_to)
		args_check(args, "wso_id", "path_from", "path_to")
		obj = find_wso(args["wso_id"])
		
		return obj.move(args["path_from"], args["path_to"])
	end
	
	def API.write(args)
		args_check(args, "wso_id", "path", "content")
		obj = find_wso(args["wso_id"])
		
		return obj.cat(args["path"], args["content"])
	end
end

Dispatcher.set_webservice("wc", API)


end
end
