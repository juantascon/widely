#
# API de WorkingCopy
#

module FS
class WorkingCopy

class API < Collection
	include Singleton
	include WebService
	
	def initialize
		super()
	end
	
	def create(args)
		args_check(args, "wc_dir", "repository_id")
		
		repository = Repository::API.instance.get_o(args["repository_id"].to_i)
		raise ArgumentError.new("repository[#{args["repository_id"]}]: invalid") if ! repository
		p repository
		
		obj = WorkingCopy.new(args["wc_dir"], repository)
		
		return save_o(obj)
	end
	
	def checkout(args)
		args_check(args, "wc_id")
		obj = get_o(args["wc_id"].to_i)
		
		return obj.checkout(args["version"])
	end

	def commit(args)
		args_check(args, "wc_id", "log")
		obj = get_o(args["wc_id"])
		
		return obj.commit(args["log"])
	end
	
	def versions(args)
		args_check(args, "wc_id")
		obj = get_o(args["wc_id"])
		
		return obj.versions()
	end
	
	def cat(args)
		args_check(args, "wc_id", "path")
		obj = get_o(args["wc_id"])
		
		return obj.cat(args["path"], args["version"])
	end
	
	def ls(args)
		args_check(args, "wc_id", "path")
		obj = get_o(args["wc_id"])
		
		return obj.ls(args["path"], args["version"])
	end
	
	def add(args)
		args_check(args, "wc_id", "path")
		obj = get_o(args["wc_id"])
		
		as_dir = args["as_dir"] == "true"
		
		return obj.add(args["path"], as_dir)
	end
	
	def delete(args)
		args_check(args, "wc_id", "path")
		obj = get_o(args["wc_id"])
		
		return obj.delete(args["path"])
	end
	
	def move(path_from, path_to)
		args_check(args, "wc_id", "path_from", "path_to")
		obj = get_o(args["wc_id"])
		
		return obj.move(args["path_from"], args["path_to"])
	end
	
	def write(args)
		args_check(args, "wc_id", "path", "content")
		obj = get_o(args["wc_id"])
		
		return obj.write(args["path"], args["content"])
	end
end

Dispatcher.set_webservice("wc", API.instance)

end
end
